{ moduleWithSystem, ... }:
{
  flake.nixosModules.darkman = moduleWithSystem (
    _perSystem@{ config, self', ... }:
    _nixos@{ pkgs, ... }:
    {
      # BUG: This service does not exist in NixOS. It only exists in home-manager,
      # because its configuration needs to be at `~/.config/darkman/config.yaml`.
      # See <https://darkman.whynothugo.nl/#CONFIGURATION>
      services.darkman = {
        enable = pkgs.stdenv.hostPlatform.isLinux;
        settings = {
          lat = 51.0;
          lng = 13.7;
        };
      };

      xdg.portal.config.common = {
        "org.freedesktop.impl.portal.Settings" = "darkman";
      };
    }
  );
}
