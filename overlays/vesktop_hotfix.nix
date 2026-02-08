# FIXME: Vesktop build failure on macOS
# See <https://github.com/NixOS/nixpkgs/issues/484618>
(final: prev: {
  vesktop = prev.vesktop.overrideAttrs (old: {
    buildPhase = ''
      runHook preBuild

      pnpm build
      pnpm exec electron-builder \
        --dir \
        -c.asarUnpack="**/*.node" \
        -c.electronDist=${if prev.stdenv.hostPlatform.isDarwin then "." else "electron-dist"} \
        -c.electronVersion=${prev.electron.version} \
        ${if prev.stdenv.hostPlatform.isDarwin then "-c.mac.identity=null" else ""}

      runHook postBuild
    '';
  });
})
