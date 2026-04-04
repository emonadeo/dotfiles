{
  withSystem,
  ...
}:
{
  flake.darwinModules.fonts =
    { pkgs, ... }:
    {
      fonts.packages = withSystem pkgs.stdenv.hostPlatform.system (
        { config, ... }:
        map (font: font.package) (
          builtins.concatLists [
            # Omit emoji font on macOS
            config.fonts.monospace
            config.fonts.sans
            config.fonts.serif
          ]
        )
      );
    };
}
