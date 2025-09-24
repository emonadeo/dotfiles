{
  config,
  pkgs,
  lib,
  ...
}:

let
  wallpaper = pkgs.fetchurl {
    url = "https://cdnb.artstation.com/p/assets/images/images/079/201/991/4k/darek-zabrocki-r2-006b-darekzabrocki.jpg";
    hash = "sha256-FEWLOc1k/jFtneG5BtkMAwmJXVdIgqit47ZjIo6qzDA=";
  };
in
{
  systemd.user.services = {
    swaybg = {
      Install = {
        WantedBy = [ "niri.service" ];
      };
      Unit = {
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
        Requisite = "graphical-session.target";
      };
      Service = {
        ExecStart = "${pkgs.swaybg + /bin/swaybg} -m fill -i \"${wallpaper}\"";
        Restart = "on-failure";
      };
    };
  };

  programs.niri = {
    settings = {
      # Make niri ask applications to omit their client-side decorations.
      prefer-no-csd = true;
      input = {
        keyboard = {
          xkb = {
            layout = "eu";
          };
        };
        mouse = {
          accel-profile = "flat";
        };
      };
      outputs = {
        "HDMI-A-2" = {
          scale = 1.667;
        };
        "HDMI-A-1" = {
          focus-at-startup = true;
          scale = 1.667;
        };
      };
      layout = {
        background-color = "transparent";
        focus-ring = {
          enable = false;
        };
        border = {
          enable = true;
          width = 4;
          inactive.color = "#ffffff44";
          active.color = "#ffffff";
        };
        default-column-width = {
          proportion = 0.66667;
        };
      };
      cursor = {
        theme = "macOS";
      };
      overview = {
        workspace-shadow.enable = false;
      };
      workspaces = {
        "main" = {
          open-on-output = "HDMI-A-1";
        };
        "terminal" = {
          open-on-output = "HDMI-A-2";
        };
        "browser" = {
          open-on-output = "HDMI-A-2";
        };
        "wildcard" = {
          open-on-output = "HDMI-A-1";
        };
        "chat" = {
          open-on-output = "HDMI-A-2";
        };
        "music" = {
          open-on-output = "HDMI-A-2";
        };
      };
      # Based on <https://yalter.github.io/niri/Getting-Started.html#main-default-hotkeys>
      binds = with config.lib.niri.actions; {
        "Mod+Q".action = close-window;
        "Mod+Shift+Q".action = quit { skip-confirmation = false; };

        "Mod+R".action = switch-preset-column-width;
        "Mod+Shift+R".action = switch-preset-window-height;
        "Mod+C".action = center-column;
        "Mod+Minus".action = set-column-width "+10%";
        "Mod+Equal".action = set-column-width "-10%";
        "Mod+Shift+Minus".action = set-window-height "+10%";
        "Mod+Shift+Equal".action = set-window-height "-10%";
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;
        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;

        "Mod+V".action = switch-focus-between-floating-and-tiling;
        "Mod+Shift+V".action = toggle-window-floating;

        "Mod+P".action = screenshot { show-pointer = true; };
        "Mod+Shift+P".action = screenshot-window { write-to-disk = false; };

        # Application Launcher
        "Mod+Space".action = spawn "fuzzel";
        # Terminal
        "Mod+T".action = spawn "ghostty";

        "Mod+1".action = focus-workspace "main";
        "Mod+2".action = focus-workspace "terminal";
        "Mod+3".action = focus-workspace "browser";
        "Mod+4".action = focus-workspace "wildcard";
        "Mod+5".action = focus-workspace "chat";
        "Mod+6".action = focus-workspace "music";

        # BUG: `move-column-to-workspace` not available as a function
        # See <https://github.com/sodiboo/niri-flake/issues/1018>
        "Mod+Shift+1".action.move-column-to-workspace = "main";
        "Mod+Shift+2".action.move-column-to-workspace = "terminal";
        "Mod+Shift+3".action.move-column-to-workspace = "browser";
        "Mod+Shift+4".action.move-column-to-workspace = "wildcard";
        "Mod+Shift+5".action.move-column-to-workspace = "chat";
        "Mod+Shift+6".action.move-column-to-workspace = "music";

        "Mod+H".action = focus-column-or-monitor-left;
        "Mod+Shift+H".action = move-column-left-or-to-monitor-left;
        "Mod+J".action = focus-window-down-or-top;
        "Mod+Shift+J".action = move-window-down;
        "Mod+K".action = focus-window-up-or-bottom;
        "Mod+Shift+K".action = move-window-up;
        "Mod+L".action = focus-column-or-monitor-right;
        "Mod+Shift+L".action = move-column-right-or-to-monitor-right;

        "Mod+Left".action = focus-column-or-monitor-left;
        "Mod+Shift+Left".action = focus-column-or-monitor-left;
        "Mod+Down".action = focus-window-down-or-top;
        "Mod+Shift+Down".action = focus-window-down-or-top;
        "Mod+Up".action = focus-window-up-or-bottom;
        "Mod+Shift+Up".action = focus-window-up-or-bottom;
        "Mod+Right".action = focus-column-or-monitor-right;
        "Mod+Shift+Right".action = focus-column-or-monitor-right;

        "Mod+Home".action = focus-column-first;
        "Mod+Shift+Home".action = move-column-to-first;
        "Mod+End".action = focus-column-last;
        "Mod+Shift+End".action = move-column-to-last;

        "Mod+Prior".action = focus-monitor-previous;
        "Mod+Shift+Prior".action = move-workspace-to-monitor-previous;
        "Mod+Next".action = focus-monitor-next;
        "Mod+Shift+Next".action = move-workspace-to-monitor-next;

        # Audio
        "XF86AudioRaiseVolume".action = spawn [
          "wpctl"
          "set-volume"
          "@DEFAULT_AUDIO_SINK@"
          "0.05+"
        ];
        "XF86AudioLowerVolume".action = spawn [
          "wpctl"
          "set-volume"
          "@DEFAULT_AUDIO_SINK@"
          "0.05-"
        ];

        "XF86AudioMute".action = spawn [
          "wpctl"
          "set-mute"
          "@DEFAULT_AUDIO_SINK@"
          "toggle"
        ];
        "XF86AudioPlay".action = spawn [
          "playerctl"
          "play-pause"
        ];
        "XF86AudioPrev".action = spawn [
          "playerctl"
          "previous"
        ];
        "XF86AudioNext".action = spawn [
          "playerctl"
          "next"
        ];
      };
      layer-rules = [
        # Put swaybg inside the overview backdrop.
        {
          matches = [ { namespace = "^wallpaper$"; } ];
          place-within-backdrop = true;
        }
      ];
      window-rules = [
        {
          clip-to-geometry = true;
          geometry-corner-radius = {
            bottom-left = 8.0;
            bottom-right = 8.0;
            top-left = 8.0;
            top-right = 8.0;
          };
        }
      ];
      gestures.hot-corners.enable = false;
      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite-unstable;
      };
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      config = {
        common = {
          default = [
            "gnome"
          ];
        };
      };
    };
  };
}
