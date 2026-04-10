{ moduleWithSystem, ... }:
{
  flake.nixosModules.terminal = moduleWithSystem (
    _perSystem@{ config, self', ... }:
    _nixos@{ pkgs, ... }:
    {
      environment.systemPackages = [
        self'.packages.ghostty
      ];

      xdg.terminal-exec = {
        enable = true;
        settings.default = [ "ghostty.desktop" ];
      };
    }
  );
}
