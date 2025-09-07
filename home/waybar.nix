{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.waybar = {
    enable = true;
    systemd = {
      target = "niri.service";
    };
  };
}
