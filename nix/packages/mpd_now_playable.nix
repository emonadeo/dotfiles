{
  perSystem =
    { pkgs, ... }:
    let
      pyobjc-framework-MediaPlayer = pkgs.python3Packages.buildPythonPackage rec {
        pname = "pyobjc-framework-MediaPlayer";
        pyproject = true;

        inherit (pkgs.python3Packages.pyobjc-core) version src;

        sourceRoot = "${src.name}/pyobjc-framework-MediaPlayer";

        build-system = [ pkgs.python3Packages.setuptools ];

        buildInputs = [ pkgs.darwin.libffi ];

        nativeBuildInputs = [
          pkgs.darwin.DarwinTools # sw_vers
        ];

        # See https://github.com/ronaldoussoren/pyobjc/pull/641. Unfortunately, we
        # cannot just pull that diff with fetchpatch due to https://discourse.nixos.org/t/how-to-apply-patches-with-sourceroot/59727.
        postPatch = ''
          substituteInPlace pyobjc_setup.py \
            --replace-fail "-buildversion" "-buildVersion" \
            --replace-fail "-productversion" "-productVersion" \
            --replace-fail "/usr/bin/sw_vers" "sw_vers" \
            --replace-fail "/usr/bin/xcrun" "xcrun"
        '';

        dependencies = with pkgs.python3Packages; [
          pyobjc-core
          pyobjc-framework-AVFoundation
        ];

        env.NIX_CFLAGS_COMPILE = toString [
          "-I${pkgs.darwin.libffi.dev}/include"
          "-Wno-error=unused-command-line-argument"
        ];

        pythonImportsCheck = [
          "Security"
          "PyObjCTools"
        ];
      };
      pyobjc-framework-AVFoundation = pkgs.python3Packages.buildPythonPackage rec {
        pname = "pyobjc-framework-AVFoundation";
        pyproject = true;

        inherit (pkgs.python3Packages.pyobjc-core) version src;

        sourceRoot = "${src.name}/pyobjc-framework-AVFoundation";

        build-system = [ pkgs.python3Packages.setuptools ];

        buildInputs = [ pkgs.darwin.libffi ];

        nativeBuildInputs = [
          pkgs.darwin.DarwinTools # sw_vers
        ];

        # See https://github.com/ronaldoussoren/pyobjc/pull/641. Unfortunately, we
        # cannot just pull that diff with fetchpatch due to https://discourse.nixos.org/t/how-to-apply-patches-with-sourceroot/59727.
        postPatch = ''
          substituteInPlace pyobjc_setup.py \
            --replace-fail "-buildversion" "-buildVersion" \
            --replace-fail "-productversion" "-productVersion" \
            --replace-fail "/usr/bin/sw_vers" "sw_vers" \
            --replace-fail "/usr/bin/xcrun" "xcrun"
        '';

        dependencies = with pkgs.python3Packages; [
          pyobjc-core
          pyobjc-framework-Cocoa
          pyobjc-framework-CoreAudio
          pyobjc-framework-CoreMedia
          pyobjc-framework-Quartz
        ];

        env.NIX_CFLAGS_COMPILE = toString [
          "-I${pkgs.darwin.libffi.dev}/include"
          "-Wno-error=unused-command-line-argument"
        ];

        pythonImportsCheck = [
          "Security"
          "PyObjCTools"
        ];
      };
      pyobjc-framework-CoreMedia = pkgs.python3Packages.buildPythonPackage rec {
        pname = "pyobjc-framework-CoreMedia";
        pyproject = true;

        inherit (pkgs.python3Packages.pyobjc-core) version src;

        sourceRoot = "${src.name}/pyobjc-framework-CoreMedia";

        build-system = [ pkgs.python3Packages.setuptools ];

        buildInputs = [ pkgs.darwin.libffi ];

        nativeBuildInputs = [
          pkgs.darwin.DarwinTools # sw_vers
        ];

        # See https://github.com/ronaldoussoren/pyobjc/pull/641. Unfortunately, we
        # cannot just pull that diff with fetchpatch due to https://discourse.nixos.org/t/how-to-apply-patches-with-sourceroot/59727.
        postPatch = ''
          substituteInPlace pyobjc_setup.py \
            --replace-fail "-buildversion" "-buildVersion" \
            --replace-fail "-productversion" "-productVersion" \
            --replace-fail "/usr/bin/sw_vers" "sw_vers" \
            --replace-fail "/usr/bin/xcrun" "xcrun"
        '';

        dependencies = with pkgs.python3Packages; [
          pyobjc-core
          pyobjc-framework-Cocoa
          pyobjc-framework-Security
        ];

        env.NIX_CFLAGS_COMPILE = toString [
          "-I${pkgs.darwin.libffi.dev}/include"
          "-Wno-error=unused-command-line-argument"
        ];

        pythonImportsCheck = [
          "Security"
          "PyObjCTools"
        ];
      };
    in
    {
      packages.mpd-now-playable = pkgs.python3Packages.buildPythonApplication rec {
        pname = "mpd-now-playable";
        version = "1.6.1";
        pyproject = true;

        src = pkgs.fetchPypi {
          pname = "mpd_now_playable";
          inherit version;
          hash = "sha256-isAiLbOwt5+nCYWbsMx40PbztnwXIcWh0vWsDNn7ZsQ=";
        };
        build-system = [ pkgs.python3Packages.pdm-backend ];
        dependencies = with pkgs.python3Packages; [
          aiocache
          pyobjc-framework-MediaPlayer
          pyobjc-framework-AVFoundation
          mpd2
          xdg-base-dirs
          pytomlpp
          yarl
          boltons
          pydantic
          rich
          ormsgpack
        ];
        meta = {
          description = "Expose your MPD server as a 'now playable' app on MacOS";
          homepage = "https://git.00dani.me/00dani/mpd-now-playable";
          mainProgram = "mpd-now-playable";
        };
      };
    };
}
