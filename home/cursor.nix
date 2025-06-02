{ pkgs, ... }:

{
  home = {
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 24;
    };
    file = {
      ".local/share/icons/macos" = {
        recursive = true;
        source = pkgs.fetchzip {
          name = "hyprcursor_macos";
          url = "https://github.com/driedpampas/macOS-hyprcursor/releases/download/v1/macOS.Hyprcursor.SVG.tar.gz";
          hash = "sha256-Iv7DCpI0LKLljyz63V01Q9EWnx7jZRPOJiX78fJtQgg=";
        };
      };
    };
  };
}
