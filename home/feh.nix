# TODO: Replace with another image viewer

{ lib, pkgs, ... }:

{
  programs.feh = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    buttons = {
      prev_img = "";
      next_img = "";
      zoom_in = 4;
      zoom_out = 5;
    };
  };
  xdg.mimeApps.defaultApplications = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    "image/bmp" = "feh.desktop";
    "image/jpeg" = "feh.desktop";
    "image/png" = "feh.desktop";
    "image/pnm" = "feh.desktop";
    "image/tiff" = "feh.desktop";
    "image/webp" = "feh.desktop";
  };
}
