# TODO: Replace with another image viewer (See `docs/image_viewers.md`)

{ ... }:

{
  programs.feh = {
    enable = true;
    buttons = {
      prev_img = "";
      next_img = "";
      zoom_in = 4;
      zoom_out = 5;
    };
  };
  xdg.mimeApps.defaultApplications = {
    "image/bmp" = "feh.desktop";
    "image/jpeg" = "feh.desktop";
    "image/png" = "feh.desktop";
    "image/pnm" = "feh.desktop";
    "image/tiff" = "feh.desktop";
    "image/webp" = "feh.desktop";
  };
}
