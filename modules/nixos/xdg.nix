{ moduleWithSystem, ... }:
{
  flake.nixosModules.xdg = moduleWithSystem (
    _perSystem@{ self', ... }:
    _nixos@{ pkgs, ... }:
    {
      programs.dconf = {
        enable = true;
        profiles.user.databases = [
          {
            settings = {
              "org/gnome/desktop/interface" = {
                color-scheme = "prefer-dark";
              };
            };
          }
        ];
      };

      xdg = {
        mime = {
          enable = true;
          defaultApplications = {
            "text/html" = "helium.desktop";
            "x-scheme-handler/about" = "helium.desktop";
            "x-scheme-handler/http" = "helium.desktop";
            "x-scheme-handler/https" = "helium.desktop";
            "x-scheme-handler/unknown" = "helium.desktop";
            "application/pdf" = "org.pwmt.zathura.desktop";
            "image/*" = "swayimg.desktop";
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
            };
          };
        };
      };
    }
  );
}
