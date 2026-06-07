{
  lib,
  moduleWithSystem,
  ...
}:
{
  flake.darwinModules.music = moduleWithSystem (
    _perSystem@{ self', ... }:
    _darwin@{ pkgs, ... }:
    let
      mpdConf = ''
        music_directory "~/Music"
        log_file "~/Library/Logs/mpd.log"
      '';
    in
    {
      environment.systemPackages = [ pkgs.rmpc ];

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
          Program = lib.getExe self'.packages.mpd-now-playable;
        };
      };
    }
  );
}
