# Undocumented flag `-l`.
# See <https://github.com/YaLTeR/niri/issues/1914>
# TODO: Launch niri in tty1
#   programs.zsh.profileExtra = lib.mkIf config.programs.niri.enable ''
#     if [ "$(tty)" = "/dev/tty1" ]; then
#       exec niri-session -l
#     fi
#   '';

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
        self'.packages.ghostty-with-env
      ];
      env = {
        EDITOR = self'.packages.neovim;
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
            natural-scroll = null;
            tap = null;
          };
        };

        outputs = {
          "HDMI-A-2" = {
            scale = 1.667;
          };
          "HDMI-A-1" = {
            focus-at-startup = null;
            scale = 1.667;
          };
        };

        layout = {
          gaps = 13.0;
          background-color = "transparent";
          focus-ring.off = null;
          border = {
            on = null;
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
            off = null;
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
          "Mod+Q".close-window = null;
          "Mod+Shift+Q".quit = {
            _attrs = {
              skip-confirmation = false;
            };
          };

          "Mod+R".switch-preset-column-width = null;
          "Mod+Shift+R".switch-preset-window-height = null;
          "Mod+C".center-column = null;
          "Mod+Minus".set-column-width = "+10%";
          "Mod+Equal".set-column-width = "-10%";
          "Mod+Shift+Minus".set-window-height = "+10%";
          "Mod+Shift+Equal".set-window-height = "-10%";
          "Mod+F".maximize-column = null;
          "Mod+Shift+F".fullscreen-window = null;
          "Mod+Comma".consume-window-into-column = null;
          "Mod+Period".expel-window-from-column = null;
          "Mod+BracketLeft".consume-or-expel-window-left = null;
          "Mod+BracketRight".consume-or-expel-window-right = null;

          "Mod+V".switch-focus-between-floating-and-tiling = null;
          "Mod+Shift+V".toggle-window-floating = null;

          # FIXME: Syntactic sugar using `config.lib.niri.actions` is currently broken.
          # See <https://github.com/sodiboo/niri-flake/issues/1380>
          "Mod+P".screenshot = {
            _attrs = {
              show-pointer = true;
            };
          };
          "Mod+Shift+P".screenshot-window = {
            _attrs = {
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

          "Mod+H".focus-column-or-monitor-left = null;
          "Mod+Shift+H".move-column-left-or-to-monitor-left = null;
          "Mod+J".focus-window-down-or-top = null;
          "Mod+Shift+J".move-window-down = null;
          "Mod+K".focus-window-up-or-bottom = null;
          "Mod+Shift+K".move-window-up = null;
          "Mod+L".focus-column-or-monitor-right = null;
          "Mod+Shift+L".move-column-right-or-to-monitor-right = null;

          "Mod+Left".focus-column-or-monitor-left = null;
          "Mod+Shift+Left".focus-column-or-monitor-left = null;
          "Mod+Down".focus-window-down-or-top = null;
          "Mod+Shift+Down".focus-window-down-or-top = null;
          "Mod+Up".focus-window-up-or-bottom = null;
          "Mod+Shift+Up".focus-window-up-or-bottom = null;
          "Mod+Right".focus-column-or-monitor-right = null;
          "Mod+Shift+Right".focus-column-or-monitor-right = null;

          "Mod+Home".focus-column-first = null;
          "Mod+Shift+Home".move-column-to-first = null;
          "Mod+End".focus-column-last = null;
          "Mod+Shift+End".move-column-to-last = null;

          "Mod+Prior".focus-monitor-previous = null;
          "Mod+Shift+Prior".move-workspace-to-monitor-previous = null;
          "Mod+Next".focus-monitor-next = null;
          "Mod+Shift+Next".move-workspace-to-monitor-next = null;

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
          {
            matches = [ { namespace = "^rofi$"; } ];
            shadow = {
              on = null;
              spread = 1024;
              offset = {
                _attrs = {
                  x = 0;
                  y = 0;
                };
              };
            };
            geometry-corner-radius = 13;
          }
        ];
        window-rules = [
          {
            clip-to-geometry = true;
            geometry-corner-radius = 8;
          }
        ];
        gestures.hot-corners.off = null;
        # Do not save screenshots
        screenshot-path = null;
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
