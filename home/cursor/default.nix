{ pkgs, ... }:

{
  home.pointerCursor = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    x11.enable = true;
    gtk.enable = true;
    name = "tahoe";
    size = 24;
    package = pkgs.stdenv.mkDerivation {
      pname = "macos-tahoe-cursor";
      version = "1.2";
      src =
        pkgs.fetchzip {
          url = "https://github.com/witt-bit/MacOS-Tahoe-Cursor/releases/download/1.2/MacOS-Tahoe-Cursor.zip";
          hash = "sha256-yr5GXQrtDl7aGFp84tpd6+IjgM9QVAlBMs9sAtrUPZc=";
        }
        + /MacOS-Tahoe-Cursor;
      installPhase = ''
        install -dm 0755 $out/share/icons
        cp -r . $out/share/icons/tahoe
      '';
    };
  };
}
