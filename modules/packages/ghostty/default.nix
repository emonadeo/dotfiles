# Adapted from <https://github.com/Lassulus/wrappers/blob/3cf1e8371129e8746d37c863c5d56a81fb16caa0/modules/ghostty/module.nix>

{ inputs, withSystem, ... }:
let
  mkTheme = themes: "light:${themes.light},dark:${themes.dark}";
  settings =
    { config, pkgs, ... }:
    {
      adjust-underline-thickness = 1;
      adjust-overline-thickness = 1;
      adjust-strikethrough-thickness = 1;
      custom-shader = [ "${./cursor_warp.glsl}" ];
      theme = mkTheme {
        dark = "${inputs.catppuccin-ghostty}/themes/catppuccin-mocha.conf";
        light = "${inputs.catppuccin-ghostty}/themes/catppuccin-latte.conf";
      };
      font-family = [
        "" # Override config at `$XDG_CONFIG_DIR/ghostty/config.ghostty`.
        (builtins.elemAt config.fonts.monospace 0).name
      ];
      # BUG: Build failure if `features` is null
      font-feature = (builtins.elemAt config.fonts.monospace 0).features.ghostty;
      font-size = 13.5;
      macos-titlebar-style = "hidden";
      window-padding-balance = true;
      window-padding-x = 16;
      window-padding-y = 16;
      window-inherit-working-directory = true;
      window-decoration = pkgs.stdenv.hostPlatform.isDarwin;
    };
  # Generate config file from `settings`
  configFile =
    ctx@{ pkgs, ... }:
    toString (
      (pkgs.formats.keyValue { listsAsDuplicateKeys = true; }).generate "config.ghostty" (settings ctx)
    );
in
{
  flake.packages."x86_64-linux".ghostty = withSystem "x86_64-linux" (
    ctx@{ config, pkgs, ... }:
    inputs.wrappers-b.lib.wrapPackage ({
      inherit pkgs;
      package = pkgs.ghostty;
      env.FONTCONFIG_FILE = (
        pkgs.makeFontsConf {
          fontDirectories = builtins.concatLists [
            (map (font: font.package) config.fonts.emoji)
            (map (font: font.package) config.fonts.monospace)
            (map (font: font.package) config.fonts.sans)
            (map (font: font.package) config.fonts.serif)
          ];
        }
      );
      filesToPatch = [
        "share/dbus-1/services/com.mitchellh.ghostty.service"
        "share/systemd/user/app-com.mitchellh.ghostty.service"
      ];
      flagSeparator = "=";
      flags = {
        "--config-file" = configFile ctx;
      };
    })
  );

  # Limitation on macOS:
  # All fonts MUST be located inside `/Library/Fonts`.
  # It is not possible to link fonts in arbitrary locations using environment variables.
  # As such the font used in Ghostty must be also be installed, e.g. setting `fonts.packages` using nix-darwin .
  flake.packages."aarch64-darwin".ghostty = withSystem "aarch64-darwin" (
    ctx@{ pkgs, ... }:
    inputs.wrappers-b.lib.wrapPackage (
      { config, ... }:
      {
        inherit pkgs;
        # TODO: Replace with `pkgs.ghostty` once available for darwin
        package = pkgs.ghostty-bin;
        # HACK: Some disgusting monkey-patching for macOS
        argv0type = (
          _: # Ignore the original command
          "open -na ${placeholder config.outputName}/Applications/Ghostty.app --args --config-file=${configFile ctx} \"$@\""
        );
      }
    )
  );
}
