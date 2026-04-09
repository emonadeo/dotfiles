# TODO: Migrate to nixpkgs once available
# See <https://github.com/imputnet/helium/issues/320>
# and <https://github.com/NixOS/nixpkgs/pull/498572>

{ withSystem, ... }:
{
  flake.packages."aarch64-darwin".helium = withSystem "aarch64-darwin" (
    { inputs', pkgs, ... }:
    pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "helium";
      version = "0.10.9.1";
      src = pkgs.fetchurl {
        url = "https://github.com/imputnet/helium-macos/releases/download/${finalAttrs.version}/helium_${finalAttrs.version}_arm64-macos.dmg";
        hash = "sha256-qLsd9TNAri8ytp2LyRiRQmCxrvC60r/JYQZCpdEP8es=";
      };
      nativeBuildInputs = [
        pkgs._7zz
        pkgs.makeBinaryWrapper
      ];
      sourceRoot = ".";
      installPhase = # sh
        ''
          runHook preInstall

          mkdir -p "$out/Applications"
          mv "Helium.app" "$out/Applications/"
          makeWrapper "$out/Applications/Helium.app/Contents/MacOS/helium" "$out/bin/helium"

          runHook postInstall
        '';
    })
  );

  flake.packages."x86_64-linux".helium = withSystem "x86_64-linux" (
    { inputs', ... }: inputs'.ev357.packages.helium
  );
}
