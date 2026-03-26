let
  mkTheme = themes: "light:${themes.light},dark:${themes.dark}";
in
{ inputs, ... }:
{
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      packages.ghostty =
        (inputs.wrappers-l.ghostty.apply {
          settings = {
            adjust-underline-thickness = 1;
            adjust-overline-thickness = 1;
            adjust-strikethrough-thickness = 1;
            custom-shader = [ "${./cursor_warp.glsl}" ];
            theme = mkTheme {
              dark = "${inputs.catppuccin-ghostty}/themes/catppuccin-mocha.conf";
              light = "${inputs.catppuccin-ghostty}/themes/catppuccin-latte.conf";
            };
            font-family = config.fonts.monospace.name;
            font-feature = config.fonts.monospace.features.ghostty;
            font-size = 13.5;
            macos-titlebar-style = "hidden";
            window-padding-balance = true;
            window-padding-x = 16;
            window-padding-y = 16;
            window-inherit-working-directory = true;
            window-decoration = pkgs.stdenv.hostPlatform.isDarwin;
          };
        }).wrapper;
    };
}
