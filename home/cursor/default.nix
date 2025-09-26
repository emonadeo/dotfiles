{ pkgs, ... }:

{
  home.pointerCursor = {
    x11.enable = true;
    gtk.enable = true;
    name = "tahoe";
    size = 24;
    package = pkgs.stdenv.mkDerivation {
      pname = "tahoe_cursor";
      version = "1.1";
      src = ./theme;
      installPhase = ''
        install -dm 0755 $out/share/icons
        cp -r . $out/share/icons/tahoe
      '';
    };
  };
}
