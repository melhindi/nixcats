{
  description = "Neovim configuration built with nix-wrapper-modules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    wrappers = {
      url = "github:nix-community/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fetched with submodules for the tree-sitter-rout grammar.
    plugins-rNvim = {
      type = "git";
      url = "https://github.com/R-nvim/R.nvim";
      submodules = true;
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
    mkNvimcom = pkgs:
      (import ./nix/r-nvim.nix {
        inherit pkgs;
        src = inputs.plugins-rNvim;
      }).nvimcom;

    module = lib.modules.importApply ./module.nix inputs;
    wrapper = wrappers.lib.evalModule module;

    # Specs that only belong in the full `nixcats` package.
    onlyWith = enabled:
      lib.genAttrs
      (lib.subtractLists enabled ["rPlugin" "zig" "latex" "typst" "python" "rust" "jj"])
      (_: false);
  in {
    # nvimcom for an R installed from the same lock as this config (e.g. your profile R):
    # `rWrapper.override { packages = [ (mkNvimcom pkgs) ]; }`. Project devShells don't
    # need it; R.nvim installs the matching nvimcom into the user R library itself.
    lib = {inherit mkNvimcom;};

    wrapperModules.default = module;
    wrappers.default = wrapper.config;

    packages = forEachSystem (system: let
      pkgs = import nixpkgs {inherit system;};
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
    in {
      inherit nixcats nixcatsTex nixcatsTypst;
      default = nixcats;
      nvimcom = mkNvimcom pkgs;
    });

    devShells = forEachSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      default = pkgs.mkShell {
        name = "nixcats";
        packages = [self.packages.${system}.default];
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
