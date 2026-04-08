{
  moduleWithSystem,
  ...
}:
{
  flake.darwinModules.ghostty = moduleWithSystem (
    _perSystem@{ config, self', ... }:
    _darwin@{ pkgs, ... }:
    {
      environment.systemPackages = [
        config.packages.ghostty
      ];

      # TODO: Include fallbacks once supported
      # See `modules/packages/ghostty.nix`
      fonts.packages = [ (builtins.elemAt config.fonts.monospace 0).package ];
    }
  );
}
