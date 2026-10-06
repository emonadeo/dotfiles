{
  lib,
  moduleWithSystem,
  self,
  ...
}:
{
  flake.darwinModules.audio = moduleWithSystem (
    _perSystem@{ self', ... }:
    _darwin@{ pkgs, ... }:
    let
      mpdAddress = "/tmp/mpd.socket";
      mpdConf = ''
        bind_to_address "${mpdAddress}"
        music_directory "~/Music"
        log_file "~/Library/Logs/mpd.log"
      '';
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

      launchd.user.agents.mpd = {
        serviceConfig = {
          Label = "com.github.musicplayerdaemon.mpd";
          KeepAlive = true;
          ProcessType = "Interactive";
          RunAtLoad = true;
          StandardOutPath = "/tmp/mpd.log";
          StandardErrorPath = "/tmp/mpd.err.log";
          ProgramArguments = [
            (lib.getExe pkgs.mpd)
            "--no-daemon"
            "${pkgs.writeText "mpd.conf" mpdConf}"
          ];
        };
      };

      launchd.user.agents.mpd-now-playable = {
        serviceConfig = {
          Label = "me.00dani.mpd-now-playable";
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/tmp/mpd-now-playable.log";
          StandardErrorPath = "/tmp/mpd-now-playable.err.log";
          EnvironmentVariables = {
            MPD_HOST = mpdAddress;
          };
          Program = lib.getExe self'.packages.mpd-now-playable;
        };
      };
    }
  );
}
