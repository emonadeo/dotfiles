# TODO: Consider (re)adding home-manager because MPD and Pipewire without it
# is a pain in the ass but i dont want another module ecosystem :(

{
  moduleWithSystem,
  self,
  ...
}:
{
  flake.nixosModules.audio = moduleWithSystem (
    _perSystem@{ self', ... }:
    _darwin@{ config, pkgs, ... }:
    let
      mpdAddress = "/run/mpd/socket";
      rmpc = self.wrappers.rmpc.wrap {
        config = {
          inherit pkgs;
          config =
            # ron
            ''
              (
                cache_dir: Some("/tmp/rmpc"),
                address: "${mpdAddress}",
              )
            '';
        };
      };
    in
    {
      environment.systemPackages = [ rmpc ];

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
          audio_output = [
            {
              type = "pipewire";
              name = "Pipewire";
            }
          ];
          # Use socket instead of TCP to prevent permission problems with
          # local files (i.e. downloaded by yt-dlp)
          bind_to_address = mpdAddress;
          # TODO: Use XDG music directory
          # This might not be doable or ugly without home manager
          music_directory = "${config.users.users.${self.lib.user.handle}.home}/Music";
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
          ExecStart = "${pkgs.mpd-mpris}/bin/mpd-mpris -no-instance -network unix -host ${mpdAddress}";
          BusName = "org.mpris.MediaPlayer2.mpd";
        };
      };
    }
  );
}
