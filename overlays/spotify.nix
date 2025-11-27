{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  spotx = inputs.spotx + /spotx.sh;
in
final: prev: {
  spotify = prev.spotify.overrideAttrs (old: {
    nativeBuildInputs =
      old.nativeBuildInputs
      ++ (with prev; [
        util-linux
        perl
        unzip
        zip
        curl
      ])
      ++ (
        if prev.stdenv.hostPlatform.isDarwin then
          with prev;
          [
            # macOS
            darwin.DarwinTools
            darwin.sigtool
            sysctl
          ]
        else
          [ ]

      );

    unpackPhase =
      if pkgs.stdenv.hostPlatform.isLinux then
        (builtins.replaceStrings
          [ "runHook postUnpack" ]
          [
            ''
              patchShebangs --build ${spotx}
              runHook postUnpack
            ''
          ]
          old.unpackPhase
        )
      else
        null;

    installPhase =
      builtins.replaceStrings
        [ "runHook postInstall" ]
        [
          (
            if pkgs.stdenv.hostPlatform.isLinux then
              ''
                bash ${spotx} -f -P "$out/share/spotify"
                runHook postInstall
              ''
            else
              ''
                bash ${spotx} -f -P "$out/Applications"
                runHook postInstall
              ''
          )
        ]
        old.installPhase;
  });
}
