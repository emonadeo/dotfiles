{
  inputs,
  lib,
  withSystem,
  ...
}:
{
  flake.packages."x86_64-linux".niri = withSystem "x86_64-linux" (
    { pkgs, self', ... }:
    let
      wallpaper = pkgs.fetchurl {
        url = "https://cdnb.artstation.com/p/assets/images/images/079/201/991/4k/darek-zabrocki-r2-006b-darekzabrocki.jpg";
        hash = "sha256-FEWLOc1k/jFtneG5BtkMAwmJXVdIgqit47ZjIo6qzDA=";
      };
      playerctl = lib.getExe pkgs.playerctl;
      wpctl = "${pkgs.wireplumber}/bin/wpctl";
    in
    inputs.wrappers-b.wrappers.niri.wrap {
      inherit pkgs;
      extraPackages = [
        pkgs.wl-clipboard
        # TODO: Should `xdg-utils` go here?
        pkgs.xdg-utils
        self'.packages.rofi
        self'.packages.ghostty
      ];
      env = {
        EDITOR = "${self'.packages.neovim}/bin/neovim";
        GDK_SCALE = "1.667";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        XCURSOR_PATH = "${self'.packages.tahoe-cursor}/share/icons";
      };
      settings = {
        # Make niri ask applications to omit their client-side decorations.
        prefer-no-csd = true;

        input = {
          keyboard = {
            xkb = {
              layout = "eu"; # EurKEY
            };
          };
          mouse = {
            accel-profile = "flat";
          };
          touchpad = {
            natural-scroll = _: { };
            tap = _: { };
          };
        };

        outputs = {
          "HDMI-A-2" = {
            scale = 1.667;
          };
          "HDMI-A-1" = {
            focus-at-startup = _: { };
            scale = 1.667;
          };
        };

        layout = {
          gaps = 13.0;
          background-color = "transparent";
          focus-ring.off = _: { };
          border = {
            on = _: { };
            width = 3;
            inactive-color = "#ffffff44";
            active-color = "#ffffff";
          };
          default-column-width = {
            proportion = 0.66667;
          };
        };

        cursor = {
          xcursor-theme = "Tahoe";
          xcursor-size = 36;
        };

        overview = {
          workspace-shadow = {
            off = _: { };
          };
        };

        workspaces = {
          "primary" = {
            open-on-output = "HDMI-A-1";
          };
          "secondary" = {
            open-on-output = "HDMI-A-2";
          };
          "tertiary" = {
            open-on-output = "HDMI-A-2";
          };
        };
        # Based on <https://yalter.github.io/niri/Getting-Started.html#main-default-hotkeys>
        binds = {
          "Mod+Q".close-window = _: { };
          "Mod+Shift+Q".quit = _: {
            props = {
              skip-confirmation = false;
            };
          };

          "Mod+R".switch-preset-column-width = _: { };
          "Mod+Shift+R".switch-preset-window-height = _: { };
          "Mod+C".center-column = _: { };
          "Mod+Minus".set-column-width = "+10%";
          "Mod+Equal".set-column-width = "-10%";
          "Mod+Shift+Minus".set-window-height = "+10%";
          "Mod+Shift+Equal".set-window-height = "-10%";
          "Mod+F".maximize-column = _: { };
          "Mod+Shift+F".fullscreen-window = _: { };
          "Mod+Comma".consume-window-into-column = _: { };
          "Mod+Period".expel-window-from-column = _: { };
          "Mod+BracketLeft".consume-or-expel-window-left = _: { };
          "Mod+BracketRight".consume-or-expel-window-right = _: { };

          "Mod+V".switch-focus-between-floating-and-tiling = _: { };
          "Mod+Shift+V".toggle-window-floating = _: { };

          # FIXME: Syntactic sugar using `config.lib.niri.actions` is currently broken.
          # See <https://github.com/sodiboo/niri-flake/issues/1380>
          "Mod+P".screenshot = _: {
            props = {
              show-pointer = true;
            };
          };
          "Mod+Shift+P".screenshot-window = _: {
            props = {
              write-to-disk = false;
            };
          };

          # Application Launcher
          "Mod+Space".spawn = [
            "rofi"
            "-show"
            "drun"
          ];
          # Terminal
          "Mod+T".spawn = "ghostty";

          "Mod+1".focus-workspace = "primary";
          "Mod+2".focus-workspace = "secondary";
          "Mod+3".focus-workspace = "tertiary";

          "Mod+Shift+1".move-column-to-workspace = "primary";
          "Mod+Shift+2".move-column-to-workspace = "secondary";
          "Mod+Shift+3".move-column-to-workspace = "tertiary";

          "Mod+H".focus-column-or-monitor-left = _: { };
          "Mod+Shift+H".move-column-left-or-to-monitor-left = _: { };
          "Mod+J".focus-window-down-or-top = _: { };
          "Mod+Shift+J".move-window-down = _: { };
          "Mod+K".focus-window-up-or-bottom = _: { };
          "Mod+Shift+K".move-window-up = _: { };
          "Mod+L".focus-column-or-monitor-right = _: { };
          "Mod+Shift+L".move-column-right-or-to-monitor-right = _: { };

          "Mod+Left".focus-column-or-monitor-left = _: { };
          "Mod+Shift+Left".focus-column-or-monitor-left = _: { };
          "Mod+Down".focus-window-down-or-top = _: { };
          "Mod+Shift+Down".focus-window-down-or-top = _: { };
          "Mod+Up".focus-window-up-or-bottom = _: { };
          "Mod+Shift+Up".focus-window-up-or-bottom = _: { };
          "Mod+Right".focus-column-or-monitor-right = _: { };
          "Mod+Shift+Right".focus-column-or-monitor-right = _: { };

          "Mod+Home".focus-column-first = _: { };
          "Mod+Shift+Home".move-column-to-first = _: { };
          "Mod+End".focus-column-last = _: { };
          "Mod+Shift+End".move-column-to-last = _: { };

          "Mod+Prior".focus-monitor-previous = _: { };
          "Mod+Shift+Prior".move-workspace-to-monitor-previous = _: { };
          "Mod+Next".focus-monitor-next = _: { };
          "Mod+Shift+Next".move-workspace-to-monitor-next = _: { };

          # Audio
          "XF86AudioRaiseVolume".spawn = [
            wpctl
            "set-volume"
            "@DEFAULT_AUDIO_SINK@"
            "0.05+"
          ];
          "XF86AudioLowerVolume".spawn = [
            wpctl
            "set-volume"
            "@DEFAULT_AUDIO_SINK@"
            "0.05-"
          ];

          "XF86AudioMute".spawn = [
            wpctl
            "set-mute"
            "@DEFAULT_AUDIO_SINK@"
            "toggle"
          ];
          "XF86AudioPlay".spawn = [
            playerctl
            "play-pause"
          ];
          "XF86AudioPrev".spawn = [
            playerctl
            "previous"
          ];
          "XF86AudioNext".spawn = [
            playerctl
            "next"
          ];
        };
        layer-rules = [
          # Put swaybg inside the overview backdrop.
          {
            matches = [ { namespace = "^wallpaper$"; } ];
            place-within-backdrop = true;
          }
          # BUG: Causes build failure
          # {
          #   matches = [ { namespace = "^rofi$"; } ];
          #   shadow = {
          #     on = _: {};
          #     spread = 1024;
          #     offset = _: {
          #       props = {
          #         x = 0;
          #         y = 0;
          #       };
          #     };
          #   };
          #   geometry-corner-radius = 13;
          # }
        ];
        window-rules = [
          {
            clip-to-geometry = true;
            geometry-corner-radius = 8;
          }
        ];
        gestures.hot-corners.off = _: { };
        # Do not save screenshots
        screenshot-path = _: { };
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        spawn-at-startup = [
          (lib.getExe (
            inputs.wrappers-b.lib.wrapPackage {
              inherit pkgs;
              package = pkgs.swaybg;
              flags = {
                "-m" = "fill";
                "-i" = wallpaper;
              };
            }
          ))
        ];
      };
    }

  );
}
