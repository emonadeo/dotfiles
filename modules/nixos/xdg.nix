{ moduleWithSystem, ... }:
{
  flake.nixosModules.xdg = moduleWithSystem (
    _perSystem@{ self', ... }:
    _nixos@{ pkgs, ... }:
    {
      xdg = {
        mime = {
          enable = true;
          defaultApplications = {
            "application/pdf" = "org.pwmt.zathura.desktop";
          };
        };
        portal = {
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-gnome
            pkgs.xdg-desktop-portal-gtk
          ];
          config = {
            common = {
              default = [
                "gtk"
                "gnome"
              ];
              "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
              # TODO: Find out whether `color-scheme` can be set to be
              # constantly `dark` using `xdg-desktop-portal-gtk` or others.
            };
          };
        };
      };
    }
  );
}
