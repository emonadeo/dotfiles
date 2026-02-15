{
  pkgs,
  ...
}:

{
  programs.mpv = {
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
      pkgs.mpvScripts.mpris
      pkgs.mpvScripts.uosc
    ];
  };
}
