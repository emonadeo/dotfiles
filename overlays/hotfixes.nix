final: prev: {
  # HACK: https://github.com/NixOS/nixpkgs/issues/418689
  python313 = prev.python313.override {
    packageOverrides = python_final: python_prev: {
      lxml-html-clean = python_prev.lxml-html-clean.overridePythonAttrs (oldAttrs: {
        doCheck = false;
      });
    };
  };

  python313Packages = final.python313.pkgs;
}
