# Adapted from <https://github.com/Lassulus/wrappers/blob/3cf1e8371129e8746d37c863c5d56a81fb16caa0/modules/ghostty/module.nix>
let
  mkTheme = themes: "light:${themes.light},dark:${themes.dark}";
in
{ inputs, lib, ... }:
{
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    let
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
        # FIXME: Build failure if `features` is null
        font-feature = config.fonts.monospace.features.ghostty or null;
        font-size = 13.5;
        macos-titlebar-style = "hidden";
        window-padding-balance = true;
        window-padding-x = 16;
        window-padding-y = 16;
        window-inherit-working-directory = true;
        window-decoration = pkgs.stdenv.hostPlatform.isDarwin;
      };
    in
    {
      packages.ghostty = (
        inputs.wrappers-b.lib.wrapPackage {
          inherit pkgs;
          package = if pkgs.stdenv.hostPlatform.isLinux then pkgs.ghostty else pkgs.ghostty-bin;
          extraPackages = [ config.fonts.monospace.package ];
          filesToPatch = lib.mkIf pkgs.stdenv.hostPlatform.isLinux [
            "share/dbus-1/services/com.mitchellh.ghostty.service"
            "share/systemd/user/app-com.mitchellh.ghostty.service"
          ];
          flagSeparator = "=";
          flags = {
            "--config-file" = toString (
              (pkgs.formats.keyValue {
                listsAsDuplicateKeys = true;
              }).generate
                "config.ghostty"
                settings
            );
          };
        }
      );
    };
}
