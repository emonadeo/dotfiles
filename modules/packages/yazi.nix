{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.yazi = (
        inputs.wrappers-b.lib.wrapPackage {
          inherit pkgs;
          package = pkgs.yazi;
          # TODO: Is this the best way to combine files into a single path?
          env.YAZI_CONFIG_HOME = pkgs.runCommand "yazi-config" { } ''
            # Copy plugins into `$out/plugins`
            mkdir -p $out/plugins
            cp -r ${pkgs.yaziPlugins.full-border} $out/plugins/full-border.yazi
            cp -r ${pkgs.yaziPlugins.git} $out/plugins/git.yazi
            cp -r ${pkgs.yaziPlugins.starship} $out/plugins/starship.yazi

            # Copy flavors into `$out/flavors`
            mkdir -p $out/flavors
            cp -r ${inputs.yazi-flavors}/catppuccin-latte.yazi $out/flavors/catppuccin-latte.yazi
            cp -r ${inputs.yazi-flavors}/catppuccin-mocha.yazi $out/flavors/catppuccin-mocha.yazi

            # Create `$out/init.lua`
            cp ${
              pkgs.writeText "init.lua"
                # lua
                ''
                  require("full-border"):setup({ type = ui.Border.ROUNDED })
                  require("git"):setup()
                  require("starship"):setup()
                ''
            } $out/init.lua

            # Create `$out/theme.toml`
            cp ${
              (pkgs.formats.toml { }).generate "theme.toml" {
                flavor = {
                  dark = "catppuccin-mocha";
                  light = "catppuccin-latte";
                };
              }
            } $out/theme.toml
          '';
        }
      );
    };
}
