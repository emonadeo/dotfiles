# TODO: Consider (re)adding home-manager because MPD and Pipewire without it
# is a pain in the ass but i dont want another module ecosystem :(

{ self, ... }:
{
  flake.nixosModules.audio =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.rmpc ];

      # Daemon for playerctld to track currently active media player
      services.playerctld.enable = true;

      # Audio server
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        jack.enable = true;
        extraConfig = {
          pipewire."99-input-denoising" = {
            "context.modules" = [
              {
                "name" = "libpipewire-module-filter-chain";
                "args" = {
                  "node.description" = "DeepFilter Noise Cancelling Source";
                  "media.name" = "DeepFilter Noise Cancelling Source";
                  "filter.graph" = {
                    "nodes" = [
                      {
                        "type" = "ladspa";
                        "name" = "DeepFilter Mono";
                        "plugin" = "${pkgs.deepfilternet}/lib/ladspa/libdeep_filter_ladspa.so";
                        "label" = "deep_filter_mono";
                      }
                    ];
                  };
                  "audio.rate" = 48000;
                  "capture.props" = {
                    "node.name" = "deep_filter_mono_input";
                    "node.passive" = true;
                  };
                  "playback.props" = {
                    "node.name" = "deep_filter_mono_output";
                    "media.class" = "Audio/Source";
                  };
                };
              }
            ];
          };
        };
      };

      # Music player daemon
      services.mpd = {
        enable = true;
        user = self.lib.user.handle;
        startWhenNeeded = true;
        settings = {
          # TODO: Use XDG music directory
          # This might not be doable or ugly without home manager
          music_directory = "${config.users.users.${self.lib.user.handle}.home}/Music";
          audio_output = [
            {
              type = "pipewire";
              name = "Pipewire";
            }
          ];
        };
      };

      # HACK: MPD and Pipewire workaround.
      # See <https://wiki.nixos.org/wiki/MPD#PipeWire_workaround>
      # and <https://github.com/NixOS/nixpkgs/issues/102547#issuecomment-1016671189>
      # and <https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609>
      #
      # Internally, `services.mpd` uses `systemd.services.mpd` instead of `systemd.user.services.mpd`.
      systemd.services.mpd.environment = {
        # BUG: Breaks if `uid` is `null`
        XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.${self.lib.user.handle}.uid}";
      };

      # MPRIS integration so MPD can be controlled with playerctl or other MPRIS utilities
      # The first party flake only provides a home-manager module
      systemd.user.services.mpd-mpris = {
        wantedBy = [ "default.target" ];
        after = [ "mpd.target" ];
        serviceConfig = {
          Type = "dbus";
          Restart = "on-failure";
          RestartSec = "5s";
          ExecStart = "${pkgs.mpd-mpris}/bin/mpd-mpris -no-instance";
          BusName = "org.mpris.MediaPlayer2.mpd";
        };
      };
    };
}
