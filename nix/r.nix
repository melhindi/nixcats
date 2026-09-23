# R runtime helpers shared by the neovim module and the R.nvim bootstrap wrapper.
{rNvimSrc}: rec {
  # Build nvimcom as part of the Nix closure so R.nvim does not need to
  # install it into a writable library at startup.
  mkNvimcom = pkgs:
    pkgs.rPackages.buildRPackage {
      pname = "nvimcom";
      version =
        builtins.elemAt (
          builtins.match
          ".*Version: ([^[:space:]]+).*"
          (builtins.readFile "${rNvimSrc}/nvimcom/DESCRIPTION")
        )
        0;
      src = "${rNvimSrc}/nvimcom";
      nativeBuildInputs = [
        pkgs.gcc
        pkgs.gnumake
      ];
    };

  # R.nvim still compiles its server from a writable checkout, but the R
  # library itself should stay in the Nix store.
  mkRRuntime = pkgs:
    pkgs.rWrapper.override {
      packages = with pkgs.rPackages; [
        (mkNvimcom pkgs)
        knitr
        sqldf
        languageserver
        rmarkdown
        styler
        Cairo
        dplyr
        ggrepel
        directlabels
      ];
    };
}
