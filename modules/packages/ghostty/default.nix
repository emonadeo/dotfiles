# Adapted from <https://github.com/Lassulus/wrappers/blob/3cf1e8371129e8746d37c863c5d56a81fb16caa0/modules/ghostty/module.nix>

{
  inputs,
  self,
  ...
}:
{
  flake.wrapperModules.ghostty =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      mkTheme = themes: "light:${themes.light},dark:${themes.dark}";
      settings = {
        adjust-underline-thickness = 1;
        adjust-overline-thickness = 1;
        adjust-strikethrough-thickness = 1;
        custom-shader = [ "${./cursor_warp.glsl}" ];
        theme = mkTheme {
          dark = "${inputs.catppuccin-ghostty}/themes/catppuccin-mocha.conf";
          light = "${inputs.catppuccin-ghostty}/themes/catppuccin-latte.conf";
        };
        font-family =
          if config.font.name != null then
            [
              "" # Override config at `$XDG_CONFIG_DIR/ghostty/config.ghostty`
              config.font.name
            ]
          else
            null;
        font-feature = config.font.features or null;
        font-size = 13.5;
        macos-titlebar-style = "hidden";
        window-padding-balance = true;
        window-padding-x = 16;
        window-padding-y = 16;
        window-inherit-working-directory = true;
        window-decoration = pkgs.stdenv.hostPlatform.isDarwin;
      };
      # Generate config file from `settings`
      configFile = toString (
        (pkgs.formats.keyValue { listsAsDuplicateKeys = true; }).generate "config.ghostty" settings
      );
    in
    {
      options = {
        # Only allow a single font, since Ghostty does not support specific font-feature on fallback fonts
        # See <https://github.com/ghostty-org/ghostty/issues/11464>
        # and <https://ghostty.org/docs/config/reference#font-feature>
        # TODO: Support fallback fonts
        font = lib.mkOption {
          description = ''
            Limitation on macOS:
            The font MUST be copied or symlinked inside `/Library/Fonts` since it is not possible
            to load fonts in outside of that folder
          '';
          default = null;
          type = lib.types.nullOr (
            lib.types.submodule {
              options = {
                name = lib.mkOption {
                  description = "Font name";
                  type = lib.types.str;
                };
                package = lib.mkOption {
                  description = "Font package";
                  type = lib.types.package;
                };
                features = lib.mkOption {
                  default = null;
                  type = lib.types.nullOr (lib.types.listOf lib.types.str);
                  description = "Font features formatted for Ghostty";
                  example = [
                    "+cv05"
                    "+cv08"
                    "-cv62"
                  ];
                };
              };
            }
          );
        };
      };

      config = {
        # TODO: Replace with `pkgs.ghostty` once available for darwin
        package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
        env.FONTCONFIG_FILE = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && config.font != null) (
          pkgs.makeFontsConf {
            fontDirectories = [ config.font.package ];
          }
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
    };

  perSystem =
    { config, pkgs, ... }:
    let
      # Use the first monospace font for Ghostty
      # TODO: Include fallbacks once supported
      font = (builtins.elemAt config.fonts.monospace 0);
    in
    {
      packages.ghostty = inputs.wrappers-b.lib.wrapPackage ({
        inherit pkgs;
        imports = [ self.wrapperModules.ghostty ];
        font = {
          inherit (font) name package;
          features = font.features.ghostty;
        };
      });
    };
}
