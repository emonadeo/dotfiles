{
  lib,
  pkgs,
  ...
}:

{
  programs.waybar = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    systemd = {
      enable = true;
      target = "niri.service";
    };

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        modules-left = [ "niri/workspaces" ];
        output = [
          "HDMI-A-1"
          "HDMI-A-2"
        ];
        "niri/workspaces" = {
          all-outputs = true;
          disable-click = true;
          format = "{icon}";
          format-icons = {
            primary = "";
            secondary = "󰔶";
            tertiary = "󰝤";
          };
        };
      };
    };
    style = ''
      window#waybar {
        background: transparent;
        color: black;
      }
      #workspaces button {
        border: none;
        padding: 0;
        padding-left: 13px;
        color: black;
        box-shadow: none;
        background: transparent;
      }
      #workspaces button:hover {
        border: none;
        box-shadow: none;
        background: transparent;
      }
      #workspaces button.focused, #workspaces button.active {
        color: white;
        box-shadow: none;
      }
    '';
  };
}
