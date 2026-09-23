{
  description = "Neovim configuration built with nix-wrapper-modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    wrappers = {
      url = "github:nix-community/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # R.nvim is not added as a plugin; the bootstrap wrapper below copies it
    # into a writable cache and prepends it to the runtimepath.
    plugins-rNvim = {
      url = "github:R-nvim/R.nvim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    wrappers,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    forEachSystem = lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ];
    inherit (import ./nix/r.nix {rNvimSrc = inputs.plugins-rNvim;}) mkRRuntime;

    module = lib.modules.importApply ./module.nix inputs;
    wrapper = wrappers.lib.evalModule module;

    # Specs that only belong in the full `nixcats` package.
    onlyWith = enabled:
      lib.genAttrs
      (lib.subtractLists enabled ["rPlugin" "zig" "latex" "typst" "python" "rust" "jj"])
      (_: false);
  in {
    wrapperModules.default = module;
    wrappers.default = wrapper.config;

    packages = forEachSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      rRuntime = mkRRuntime pkgs;
      nixcats = wrapper.config.wrap {inherit pkgs;};
      nixcatsTex = wrapper.config.wrap {
        inherit pkgs;
        binName = "ntex";
        settings.aliases = [];
        settings.categories = onlyWith ["latex"];
      };
      nixcatsTypst = wrapper.config.wrap {
        inherit pkgs;
        binName = "ntyp";
        settings.aliases = [];
        settings.categories = onlyWith ["typst"];
      };
      bootstrapNvim = pkgs.writeShellApplication {
        name = "nvim";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.gcc
          pkgs.gnumake
          pkgs.gnutar
          pkgs.gnugrep
          pkgs.gnused
          pkgs.tree-sitter
        ];
        text = ''
                set -euo pipefail

                real_nvim="${nixcats}/bin/nixcats"
                cache_root="''${XDG_CACHE_HOME:-$HOME/.cache}/nvim-bootstrap"
                r_root="$cache_root/r.nvim"
                r_src="${inputs.plugins-rNvim}"

                mkdir -p "$cache_root"
                export PATH="${rRuntime}/bin:$PATH"
                export RNVIM_BOOTSTRAP_HOME="$r_root"

                if [ ! -f "$r_root/.source" ] || [ "$(cat "$r_root/.source")" != "$r_src" ]; then
                  rm -rf "$r_root"
                  mkdir -p "$r_root"
                  cp -a "$r_src/." "$r_root/"
                  chmod -R u+rwX "$r_root"
                  printf '%s\n' "$r_src" > "$r_root/.source"
                fi

                if ! grep -q 'local grammar = config.rnvim_home .. "/resources/tree-sitter-rout/grammar.js"' "$r_root/lua/r/config.lua"; then
                  sed -i '/local check_rout_parser = function()/a\
          local grammar = config.rnvim_home .. "/resources/tree-sitter-rout/grammar.js"\
          if vim.fn.filereadable(grammar) ~= 1 then return end' "$r_root/lua/r/config.lua"
                  sed -i 's#local mt1 = mtime(config.rnvim_home .. "/resources/tree-sitter-rout/grammar.js")#local mt1 = mtime(grammar)#' "$r_root/lua/r/config.lua"
                fi

                exec "$real_nvim" --cmd "set runtimepath^=$r_root" "$@"
        '';
      };
    in {
      inherit nixcats nixcatsTex nixcatsTypst;
      default = bootstrapNvim;
      nvim-bootstrap = bootstrapNvim;
    });

    devShells = forEachSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      default = pkgs.mkShell {
        name = "nixcats";
        packages = [
          self.packages.${system}.default
          self.packages.${system}.nixcats
        ];
      };
    });

    overlays.default = final: prev: {
      nixcats = self.wrappers.default.wrap {pkgs = final;};
    };

    # Enable with `wrappers.neovim.enable = true;`; any module option can be set there.
    nixosModules.default = wrappers.lib.getInstallModule {
      name = "neovim";
      value = module;
    };
    homeModules.default = self.nixosModules.default;
  };
}
