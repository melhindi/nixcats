inputs: {
  config,
  wlib,
  lib,
  pkgs,
  options,
  ...
}: let
  rNvim = import ./nix/r-nvim.nix {
    inherit pkgs;
    src = inputs.plugins-rNvim;
  };
  enabled = name: config.settings.categories.${name} or true;
in {
  imports = [wlib.wrapperModules.neovim];

  # The lua config in this repository (init.lua, lua/, plugin/, luasnippets/).
  config.settings.config_directory = ./.;

  # Variants override these, so they are only defaults.
  # dont_link allows installing several variants side by side.
  config.binName = lib.mkDefault "nixcats";
  config.settings.aliases = lib.mkDefault ["nvim"];
  config.settings.dont_link = true;

  # Toggle top level specs per variant, e.g. `settings.categories.zig = false;`.
  # (Spec attrsets without a `data` field would be read as plugin data instead.)
  options.settings.categories = lib.mkOption {
    type = lib.types.attrsOf lib.types.bool;
    default = {};
  };

  options.settings.colorscheme = lib.mkOption {
    type = lib.types.str;
    default = "gruvbox";
  };

  # Categories (enabled top level specs) plus the colorscheme, read from lua
  # through the `nixCats` shim in init.lua.
  config.info.categories =
    (builtins.mapAttrs (_: v: v.enable) config.specs)
    // {inherit (config.settings) colorscheme;};

  # Give specs a runtimePkgs field; packages of disabled specs are dropped.
  config.specMods = {...}: {
    options.runtimePkgs =
      options.runtimePkgs
      // {
        description = ''
          A runtimePkgs spec field to put packages on the PATH.
          If the spec is disabled, this value will not be included in the resulting neovim derivation.
        '';
      };
  };
  config.runtimePkgs = config.specCollect (acc: v: acc ++ (v.runtimePkgs or [])) [];

  config.specs.general = {
    enable = enabled "general";
    data = with pkgs.vimPlugins; [
      friendly-snippets
      luasnip
      blink-cmp
      nvim-lspconfig
      nvim-treesitter-textobjects
      nvim-treesitter.withAllGrammars
      snacks-nvim
      flash-nvim
      nerdcommenter
      vim-tmux-navigator
      which-key-nvim
      neo-tree-nvim
      oil-nvim
      yanky-nvim
      mini-operators
      mini-pairs
      mini-surround
      lualine-nvim
    ];
    runtimePkgs = with pkgs; [
      lua-language-server
      stylua
      nixd
      tree-sitter
    ];
  };

  config.specs.themer = {
    enable = enabled "themer";
    data = builtins.getAttr config.settings.colorscheme (with pkgs.vimPlugins; {
      "onedark" = onedark-nvim;
      "catppuccin" = catppuccin-nvim;
      "catppuccin-mocha" = catppuccin-nvim;
      "tokyonight" = tokyonight-nvim;
      "tokyonight-day" = tokyonight-nvim;
      "gruvbox" = gruvbox-nvim;
    });
  };

  # Not enabled in any variant, same as before the migration.
  config.settings.categories.cpp = lib.mkDefault false;
  config.specs.cpp = {
    enable = enabled "cpp";
    data = null;
    runtimePkgs = with pkgs; [
      gcc
      gnumake
    ];
  };

  config.specs.zig = {
    enable = enabled "zig";
    data = [pkgs.vimPlugins.zig-vim];
    runtimePkgs = with pkgs; [
      zls
      zig
    ];
  };

  config.specs.latex = {
    enable = enabled "latex";
    data = [pkgs.vimPlugins.vimtex];
    runtimePkgs = [pkgs.texlab];
  };

  config.specs.python = {
    enable = enabled "python";
    data = null;
    runtimePkgs = [pkgs.basedpyright];
  };

  config.specs.rust = {
    enable = enabled "rust";
    data = null;
    runtimePkgs = [pkgs.rust-analyzer];
  };

  config.specs.typst = {
    enable = enabled "typst";
    data = null;
    runtimePkgs = with pkgs; [
      tinymist
      typst
    ];
  };

  config.specs.jj = {
    enable = enabled "jj";
    data = with pkgs.vimPlugins; [
      jj-nvim
      hunk-nvim
    ];
    runtimePkgs = [pkgs.jujutsu];
  };

  # R itself comes from outside (your profile or a project devShell), see
  # `lib.mkNvimcom` in flake.nix. R.nvim runs `make` on startup (a no-op, as
  # rnvimserver is prebuilt) and fails without it.
  config.specs.rPlugin = {
    enable = enabled "rPlugin";
    data = [rNvim.plugin];
    runtimePkgs = [pkgs.gnumake];
  };
}
