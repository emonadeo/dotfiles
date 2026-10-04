{
  inputs,
  self,
  ...
}:
{

  perSystem =
    {
      config,
      lib,
      pkgs,
      self',
      ...
    }:
    let
      fontsConf = pkgs.makeFontsConf {
        fontDirectories = map (font: font.package) config.fonts.monospace;
      };
      mkTheme = themes: "light:${themes.light},dark:${themes.dark}";
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
    in
    {
      packages.ghostty = inputs.wrappers-b.wrappers.ghostty.wrap ({
        inherit pkgs settings;
        env.FONTCONFIG_FILE = lib.mkIf pkgs.stdenv.hostPlatform.isLinux fontsConf;
        meta.description = ''
          Preconfigured Ghostty
        '';
      });

      # BUG: On macOS the nix-darwin environment is not available because zsh invocation is skipped.
      # This includes most notably the `nix` command.
      # See <https://github.com/nix-darwin/nix-darwin/blob/06648f4902343228ce2de79f291dd5a58ee12146/modules/programs/zsh/default.nix#L150-L175>
      packages.ghostty-with-env = inputs.wrappers-b.wrappers.ghostty.wrap ({
        inherit pkgs settings;
        env.FONTCONFIG_FILE = lib.mkIf pkgs.stdenv.hostPlatform.isLinux fontsConf;
        flags = {
          "--command" = "${self'.packages.nushell}/bin/nu";
        };
        meta.description = ''
          Preconfigured Ghostty with Nushell environment
        '';
      });
    };
}
