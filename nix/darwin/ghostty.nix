{ moduleWithSystem, ... }:
{
  flake.darwinModules.ghostty = moduleWithSystem (
    _perSystem@{ config, self', ... }:
    _darwin@{ pkgs, ... }:
    {
      environment.systemPackages = [
        self'.packages.ghostty
      ];

      fonts.packages = map (font: font.package) config.fonts.monospace;
    }
  );
}
