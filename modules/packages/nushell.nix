{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    let
      nix-index = inputs.nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.nix-index-with-db;
    in
    {
      packages.nushell = (
        inputs.wrappers-b.wrappers.nushell.wrap {
          inherit pkgs;
          extraPackages = [ self'.packages.yazi ];
          "config.nu".content = # nu
            ''
              $env.config.cursor_shape.emacs = "line"
              $env.config.cursor_shape.vi_insert = "line"
              $env.config.cursor_shape.vi_normal = "block"
              $env.config.edit_mode = "vi"
              $env.config.hooks.command_not_found = source "${nix-index}/etc/profile.d/command-not-found.nu"
              $env.config.render_right_prompt_on_last_line = true

              $env.PROMPT_INDICATOR_VI_INSERT = {||}
              $env.PROMPT_INDICATOR_VI_NORMAL = {||}

              # Integrate yazi (`y` command to change directory with yazi)
              # See <https://github.com/nix-community/home-manager/blob/86014e836ca6f4a04d59b85111d39660bdda01cd/modules/programs/yazi.nix#L254-L264>
              def --env y [...args] {
                let tmp = (mktemp -t "yazi-cwd.XXXXX")
                ^yazi ...$args --cwd-file $tmp
                let cwd = (open $tmp)
                if $cwd != "" and $cwd != $env.PWD {
                  cd $cwd
                }
                rm -fp $tmp
              }

              # Starship prompt
              # Source: <https://github.com/nix-community/home-manager/blob/e2e5f512b33ed19a7a3271d0b73ed5eefcc0be5f/modules/programs/starship.nix#L168-L179>
              use ${
                pkgs.runCommand "starship-nushell-config.nu" { } ''
                  ${pkgs.lib.getExe self'.packages.starship} init nu >> "$out"
                ''
              }
            '';
        }
      );
    };
}
