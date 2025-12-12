{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  fonts = import ../../fonts.nix { inherit lib pkgs; };
  mkTheme = themes: "light:${themes.light},dark:${themes.dark}";
in
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
    package = if pkgs.stdenv.hostPlatform.isLinux then pkgs.ghostty else pkgs.ghostty-bin;
    settings = {
      adjust-underline-thickness = 1;
      adjust-overline-thickness = 1;
      adjust-strikethrough-thickness = 1;
      custom-shader = [ "${./cursor_warp.glsl}" ];
      theme = mkTheme {
        dark = inputs.catppuccin-ghostty + /themes/catppuccin-mocha.conf;
        light = inputs.catppuccin-ghostty + /themes/catppuccin-latte.conf;
      };
      font-family = fonts.maple-mono.name;
      font-feature = fonts.maple-mono.features.ghostty;
      font-size = 13.5;
      macos-titlebar-style = "hidden";
      window-padding-balance = true;
      window-padding-x = 16;
      window-padding-y = 16;
      window-inherit-working-directory = true;
      window-decoration = pkgs.stdenv.hostPlatform.isDarwin;
    };
  };
}
