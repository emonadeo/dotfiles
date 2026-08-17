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

        dependencies = [
          pkgs.python3Packages.pyobjc-core
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

        dependencies = [
          pkgs.python3Packages.pyobjc-core
          pkgs.python3Packages.pyobjc-framework-Cocoa
          pkgs.python3Packages.pyobjc-framework-CoreAudio
          pkgs.python3Packages.pyobjc-framework-Quartz
          pyobjc-framework-CoreMedia
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

        dependencies = [
          pkgs.python3Packages.pyobjc-core
          pkgs.python3Packages.pyobjc-framework-Cocoa
          pkgs.python3Packages.pyobjc-framework-Security
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
        dependencies = [
          pkgs.python3Packages.aiocache
          pkgs.python3Packages.boltons
          pkgs.python3Packages.ormsgpack
          pkgs.python3Packages.pydantic
          pkgs.python3Packages.python-mpd2
          pkgs.python3Packages.pytomlpp
          pkgs.python3Packages.rich
          pkgs.python3Packages.xdg-base-dirs
          pkgs.python3Packages.yarl
          pyobjc-framework-AVFoundation
          pyobjc-framework-MediaPlayer
        ];
        meta = {
          description = "Expose your MPD server as a 'now playable' app on MacOS";
          homepage = "https://git.00dani.me/00dani/mpd-now-playable";
          mainProgram = "mpd-now-playable";
        };
      };
    };
}
