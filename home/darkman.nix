{ lib, pkgs, ... }:

{
  services.darkman = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    settings = {
      lat = 51.0;
      lng = 13.7;
    };
  };
  xdg.portal.config.common = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    "org.freedesktop.impl.portal.Settings" = "darkman";
  };
}
