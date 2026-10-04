# Adapted from <https://github.com/Lassulus/wrappers/blob/3cf1e8371129e8746d37c863c5d56a81fb16caa0/modules/ghostty/module.nix>

# TODO: Investigate new first-party ghostty wrapper module
# See <https://nix-community.github.io/nix-wrapper-modules/wrapperModules/ghostty.html>

{ getSystem, inputs, ... }:
{

  flake.wrappers.ghostty =
    {
      config,
      lib,
      pkgs,
      wlib,
      ...
    }:
    let
      mkTheme = themes: "light:${themes.light},dark:${themes.dark}";
      config = getSystem pkgs.stdenv.hostPlatform.system;
      settings = {
        adjust-underline-thickness = 1;
        adjust-overline-thickness = 1;
        adjust-strikethrough-thickness = 1;
        custom-shader = [
          "${inputs.cursor-shaders}/ghostty/cursor_warp.glsl"
          "${inputs.cursor-shaders}/ghostty/sonic_boom_cursor.glsl"
        ];
        theme = mkTheme {
          dark = "${inputs.catppuccin-ghostty}/themes/catppuccin-mocha.conf";
          light = "${inputs.catppuccin-ghostty}/themes/catppuccin-latte.conf";
        };
        # Add "" to override config at `$XDG_CONFIG_DIR/ghostty/config.ghostty` instead of adding as fallbacks
        font-family = [ "" ] ++ (map (font: font.name) config.fonts.monospace);
        # TODO: Add font-specific font features once ghostty supports it.
        # See <https://github.com/ghostty-org/ghostty/issues/11464>
        # and <https://ghostty.org/docs/config/reference#font-feature>.
        # For now use font features of the topmost font.
        font-feature = (builtins.elemAt config.fonts.monospace 0).features.ghostty or null;
        font-size = 13.5;
        macos-titlebar-style = "hidden";
        window-padding-balance = true;
        window-padding-x = 16;
        window-padding-y = 16;
        window-inherit-working-directory = true;
        window-decoration = pkgs.stdenv.hostPlatform.isDarwin;
        # TODO: Add keybinds once Ghostty supports select and copy actions.
        # See <https://github.com/ghostty-org/ghostty/discussions/3708>
      };
      # Generate config file from `settings`
      configFile = toString (
        (pkgs.formats.keyValue { listsAsDuplicateKeys = true; }).generate "config.ghostty" settings
      );
    in
    {
      imports = [ wlib.modules.default ];
      # TODO: Replace with `pkgs.ghostty` once available for darwin
      package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
      env.FONTCONFIG_FILE = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
        pkgs.makeFontsConf { fontDirectories = map (font: font.package) config.fonts.monospace; }
      );
      filesToPatch = lib.mkIf pkgs.stdenv.hostPlatform.isLinux [
        "share/dbus-1/services/com.mitchellh.ghostty.service"
        "share/systemd/user/app-com.mitchellh.ghostty.service"
      ];
      flagSeparator = "=";
      flags = {
        "--config-file" = configFile;
      };
      # HACK: Some monkey-patching for macOS
      # See <https://github.com/BirdeeHub/nix-wrapper-modules/discussions/409>
      wrapperVariants.ghostty = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        wrapperImplementation = "binary";
        exePath = "Applications/Ghostty.app/Contents/MacOS/ghostty";
        binDir = "Applications/Ghostty.app/Contents/MacOS";
      };
    };
}
