{ inputs, lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.spotify = pkgs.spotify.overrideAttrs (old: {
        nativeBuildInputs =
          old.nativeBuildInputs
          ++ ([
            pkgs.bashNonInteractive
            pkgs.perl
            pkgs.unzip
            pkgs.zip
            pkgs.curl
          ])
          ++ (lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
            pkgs.darwin.DarwinTools
            pkgs.darwin.sigtool
            pkgs.sysctl
          ]);

        installPhase =
          let
            path = if pkgs.stdenv.hostPlatform.isLinux then "$out/share/spotify" else "$out/Applications";
          in
          builtins.replaceStrings
            [ "runHook postInstall" ]
            [
              ''
                SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" bash ${inputs.spotx + /spotx.sh} --force --blockupdates -P "${path}"
                runHook postInstall
              ''
            ]
            old.installPhase;
      });
    };
}
