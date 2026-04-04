{ inputs, ... }:
{
  perSystem =
    {
      inputs',
      pkgs,
      self',
      ...
    }:
    let
      nix-index = inputs'.nix-index-database.packages.nix-index-with-db;
    in
    {
      packages.nushell = (
        inputs.wrappers-b.wrappers.nushell.wrap (
          { config, ... }:
          {
            inherit pkgs;
            extraPackages = [
              nix-index
              pkgs.imagemagick
              self'.packages.git
              self'.packages.jujutsu
              self'.packages.neovim
              self'.packages.starship
              self'.packages.yazi
            ];

            "config.nu".content = # nu
              ''
                $env.config.edit_mode = "vi"
                # Remove vi mode indicator from prompt
                $env.PROMPT_INDICATOR_VI_INSERT = {||}
                $env.PROMPT_INDICATOR_VI_NORMAL = {||}
                # Instead, use cursor shape to communicate current vi mode
                $env.config.cursor_shape.emacs = "line"
                $env.config.cursor_shape.vi_insert = "line"
                $env.config.cursor_shape.vi_normal = "block"

                # Query nixpkgs for invalid commands
                $env.config.hooks.command_not_found = source "${nix-index}/etc/profile.d/command-not-found.nu"

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
                  pkgs.runCommand "nushell-starship" { buildInputs = [ self'.packages.starship ]; }
                    # sh
                    ''
                      starship init nu >> "$out"
                    ''
                }
                # Correctly position right prompt of starship
                $env.config.render_right_prompt_on_last_line = true
              '';

            # HACK: Make nushell available inside of itself.
            prefixVar = [
              [
                "PATH"
                ":"
                "${placeholder config.outputName}${config.wrapperPaths.relDir}"
              ]
            ];
          }
        )
      );
    };
}
