{ withSystem, ... }:
{
  flake.packages."aarch64-darwin".affinity = withSystem "aarch64-darwin" (
    { pkgs, ... }:
    let
      version = "3.2.1";
      versionId = "4425";
    in
    pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "affinity";
      inherit version;
      src = pkgs.fetchurl {
        url = "https://affinity-update.s3.amazonaws.com/mac2/retail/Affinity%20Affinity%20Store%20${versionId}.zip";
        hash = "sha256-ui1cNilv8xvzhBCUTyKNWxam5um+fV5ZYAV0aP9kS2k=";
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
    { pkgs, ... }: pkgs.affinity-v3
  );
}
