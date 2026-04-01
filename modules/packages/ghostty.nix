# Adapted from <https://github.com/Lassulus/wrappers/blob/3cf1e8371129e8746d37c863c5d56a81fb16caa0/modules/ghostty/module.nix>

{
  inputs,
  self,
  withSystem,
  ...
}:
let
  wrapperModule =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      mkTheme = themes: "light:${themes.light},dark:${themes.dark}";
      # Only use a single font, since Ghostty does not support font-specific font features
      # See <https://github.com/ghostty-org/ghostty/issues/11464>
      # and <https://ghostty.org/docs/config/reference#font-feature>
      # TODO: Include fallbacks once supported
      font = withSystem pkgs.stdenv.hostPlatform.system (
        { config, ... }: (builtins.elemAt config.fonts.monospace 0)
      );
      settings = {
        adjust-underline-thickness = 1;
        adjust-overline-thickness = 1;
        adjust-strikethrough-thickness = 1;
        custom-shader-animation = false;
        custom-shader = [
          "${inputs.ghostty-cursor-shaders}/cursor_warp.glsl"
          "${inputs.ghostty-cursor-shaders}/sonic_boom_cursor.glsl"
        ];
        theme = mkTheme {
          dark = "${inputs.catppuccin-ghostty}/themes/catppuccin-mocha.conf";
          light = "${inputs.catppuccin-ghostty}/themes/catppuccin-latte.conf";
        };
        font-family = [
          "" # Override config at `$XDG_CONFIG_DIR/ghostty/config.ghostty`
          font.name
        ];
        font-feature = font.features.ghostty or null;
        font-size = 13.5;
        macos-titlebar-style = "hidden";
        window-padding-balance = true;
        window-padding-x = 16;
        window-padding-y = 16;
        window-inherit-working-directory = true;
        window-decoration = pkgs.stdenv.hostPlatform.isDarwin;
        # TODO: Add select and copy actions once Ghostty supports it.
        # See <https://github.com/ghostty-org/ghostty/discussions/3708>
        keybind = [
          "ctrl+j=scroll_page_lines:1"
          "ctrl+k=scroll_page_lines:-1"
          "ctrl+d=scroll_page_down"
          "ctrl+u=scroll_page_up"
          "ctrl+slash=start_search"
          "ctrl+n=navigate_search:next"
          "ctrl+shift+n=navigate_search:previous"
        ];
      };
      # Generate config file from `settings`
      configFile = toString (
        (pkgs.formats.keyValue { listsAsDuplicateKeys = true; }).generate "config.ghostty" settings
      );
    in
    {
      # TODO: Replace with `pkgs.ghostty` once available for darwin
      package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
      env.FONTCONFIG_FILE = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (
        pkgs.makeFontsConf { fontDirectories = [ font.package ]; }
      );
      filesToPatch = lib.mkIf pkgs.stdenv.hostPlatform.isLinux [
        "share/dbus-1/services/com.mitchellh.ghostty.service"
        "share/systemd/user/app-com.mitchellh.ghostty.service"
      ];
      flagSeparator = lib.mkIf pkgs.stdenv.hostPlatform.isLinux "=";
      flags = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        "--config-file" = configFile;
      };
      # HACK: Some disgusting monkey-patching for macOS
      argv0type = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
        _: # Ignore the original command
        "open -na ${placeholder config.outputName}/Applications/Ghostty.app --args --config-file=${configFile} \"$@\""
      );
    };
in
{
  perSystem =
    {
      config,
      pkgs,
      self',
      ...
    }:
    {
      packages.ghostty = inputs.wrappers-b.lib.wrapPackage ({
        inherit pkgs;
        imports = [ wrapperModule ];
        meta.description = ''
          Preconfigured Ghostty
        '';
      });

      packages.ghostty-with-env = inputs.wrappers-b.lib.wrapPackage ({
        inherit pkgs;
        imports = [ wrapperModule ];
        flags = {
          "--command" = "${self'.packages.nushell}/bin/nu";
        };
        meta.description = ''
          Preconfigured Ghostty with Nushell environment
        '';
      });
    };
}
