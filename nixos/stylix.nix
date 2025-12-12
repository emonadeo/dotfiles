{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  fonts = import ../fonts.nix { inherit lib pkgs; };
in
{
  stylix = {
    enable = true;
    cursor = {
      name = "macOS";
      package = pkgs.apple-cursor;
      size = 24;
    };
    base16Scheme = {
      base00 = "#1B2423"; # conifer 1 (black)
      base01 = "#232F2D"; # conifer 2
      base02 = "#2B3B37"; # conifer 3
      base03 = "#384D48"; # conifer 4 (bright black)
      base04 = "#455E59"; # conifer 5
      base05 = "#A8C7C0"; # conifer 7 (white)
      base06 = "#67837E"; # conifer 6
      base07 = "#DDE5ED"; # conifer 8 (bright white)
      base08 = "#F47653"; # red
      base09 = "#FFC757"; # orange
      base0A = "#FFFF57"; # yellow
      base0B = "#A7E372"; # green
      base0C = "#82FCDC"; # teal
      base0D = "#7ACAF5"; # blue
      base0E = "#D488E7"; # purple
      base0F = "#FFFFFF"; # TODO: set color
    };
    fonts = {
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
      monospace = { inherit (fonts.maple-mono) package name; };
      emoji = {
        package = inputs.apple-emoji.packages.x86_64-linux.default;
        name = "Apple Color Emoji";
      };
    };
    targets = {
      nixvim.enable = false;
      nvf.enable = false;
    };
  };
}
