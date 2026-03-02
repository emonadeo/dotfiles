{
  lib,
  pkgs,
  ...
}:

{
  # BUG: Build failure on macOS
  # See <https://github.com/NixOS/nixpkgs/issues/493775>
  programs.mpv = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    config = {
      # Builtin profiles:
      # - fast: can run on any hardware
      # - default: balanced profile between quality and performance
      # - high-quality: out of the box high quality experience. Intended mostly for dGPU.
      profile = "high-quality";
      ytdl-format = "bestvideo+bestaudio";
    };
    scripts = [
      pkgs.mpvScripts.uosc
    ]
    ++ (
      if pkgs.stdenv.hostPlatform.isLinux then
        [
          pkgs.mpvScripts.mpris
        ]
      else
        [ ]
    );
  };
}
