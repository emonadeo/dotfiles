{
  pkgs,
  ...
}:

{
  programs.waybar = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    systemd = {
      target = "niri.service";
    };
  };
}
