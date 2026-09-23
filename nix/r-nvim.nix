# R.nvim built entirely at Nix build time, so nothing has to be compiled
# into the read-only plugin directory at runtime.
# `src` is the R.nvim checkout, including the tree-sitter-rout submodule.
{
  pkgs,
  src,
}: rec {
  # R package matching this R.nvim version. Worth adding to an R installed from
  # the same lock as this config (your profile R). Any other R, e.g. in a project
  # devShell, needs nothing: R.nvim installs the matching nvimcom into the user
  # R library on first use (see the tar patch below).
  nvimcom = pkgs.rPackages.buildRPackage {
    pname = "nvimcom";
    version =
      builtins.elemAt (
        builtins.match
        ".*Version: ([^[:space:]]+).*"
        (builtins.readFile "${src}/nvimcom/DESCRIPTION")
      )
      0;
    src = "${src}/nvimcom";
  };

  # Highlights R output in hover and resolve windows.
  routGrammar = pkgs.tree-sitter.buildGrammar {
    language = "rout";
    version = "0-unstable";
    src = "${src}/resources/tree-sitter-rout";
    generate = true;
  };

  plugin = pkgs.stdenv.mkDerivation {
    pname = "R.nvim";
    version = "unstable";
    inherit src;

    # Store mtimes are all equal, so R.nvim would consider the prebuilt parser
    # outdated and try to rebuild it inside the store.
    postPatch = ''
      substituteInPlace lua/r/config.lua \
        --replace-fail "if mt1 and mt2 and mt2 > mt1 then return end" \
                       "if mt1 and mt2 and mt2 >= mt1 then return end"

      # When the R in use lacks nvimcom, R.nvim tars it from the plugin directory
      # and installs it. Files from the store are read-only, which makes the
      # unpacking in R fail; store them as writable in the tarball.
      substituteInPlace lua/r/server.lua \
        --replace-fail '{ "tar", "--no-xattrs", "-czf", nvc_fn, "nvimcom" }' \
                       '{ "tar", "--no-xattrs", "--mode=u+w", "-czf", nvc_fn, "nvimcom" }'
    '';

    # R.nvim still runs `make` at startup; with the binary prebuilt it is a no-op.
    buildPhase = ''
      runHook preBuild
      make -C rnvimserver
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r . $out
      install -Dm755 ${routGrammar}/parser $out/parser/rout.so
      runHook postInstall
    '';
  };
}
