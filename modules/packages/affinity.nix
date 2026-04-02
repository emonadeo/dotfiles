{ withSystem, ... }:
{
  flake.packages."aarch64-darwin".affinity = withSystem "aarch64-darwin" (
    { inputs', pkgs, ... }:
    let
      version = "3.1.0";
      versionId = "4231";
    in
    pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "affinity";
      inherit version;
      src = pkgs.fetchurl {
        url = "https://affinity-update.s3.amazonaws.com/mac2/retail/Affinity%20Affinity%20Store%20${versionId}.zip";
        hash = "sha256-PVOeKjLY0tl3j1N1UZt6PnLvRuzJg5ZbyYyZ1uYsby4=";
      };
      nativeBuildInputs = [
        pkgs.makeBinaryWrapper
        pkgs.unzip
      ];
      installPhase = ''
        runHook preInstall

        mkdir -p "$out/Applications/Affinity.app"
        mv * "$out/Applications/Affinity.app"
        makeWrapper "$out/Applications/Affinity.app/Contents/MacOS/Affinity Affinity Store" "$out/bin/affinity"

        runHook postInstall
      '';
    })
  );
  flake.packages."x86_64-linux".affinity = withSystem "x86_64-linux" (
    { inputs', ... }: inputs'.affinity.packages.default
  );
}
