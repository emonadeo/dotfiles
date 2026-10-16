{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.starship = (
        inputs.wrappers.wrappers.starship.wrap {
          inherit pkgs;
          settings = {
            line_break.disabled = true;
            format = inputs.nixpkgs.lib.concatStrings [
              "$nix_shell"
              "$shlvl"
              "$directory"
              "$vcs"
              "[ ](bg:#101817)"
              "[](fg:#101817)"
              " "
            ];
            right_format = inputs.nixpkgs.lib.concatStrings [
              "$c"
              "$dart"
              "$deno"
              "$elixir"
              "$gleam"
              "$golang"
              "$haskell"
              "$java"
              "$kotlin"
              "$lua"
              "$nodejs"
              "$ocaml"
              "$php"
              "$python"
              "$rust"
              "$zig"
            ];

            # Left

            # BUG: Starship can detect `nix-shell` but not `nix shell`
            # See <https://github.com/NixOS/nix/issues/6677>
            nix_shell = {
              format = "[ $symbol ($name )]($style)[](fg:blue bg:#101817)";
              style = "fg:#101817 bg:blue";
              symbol = "";
            };
            shlvl = {
              disabled = false;
              format = "[ $symbol $shlvl ]($style)[]($style fg:bright-black)";
              style = "fg:white bg:#101817";
              symbol = "󰁄";
            };
            directory = {
              format = "[ $path]($style)[$read_only]($read_only_style)";
              style = "bold fg:blue bg:#101817";
              read_only = " ";
              read_only_style = "bold fg:red bg:#101817";
            };
            vcs = {
              order = [
                "jj"
                "git"
              ];
              jj_modules = "$jj_bookmark$jj_status$jj_metrics";
            };
            git_branch = {
              format = "[ ]($style fg:bright-black)[ $symbol $branch(:$remote_branch)(@$remote_name) ]($style)";
              style = "fg:purple bg:#101817";
              symbol = "";
            };
            jj_bookmark = {
              format = "[ ]($style fg:bright-black)[ $symbol $bookmark(@$remote)$diverged( \\(+$overflow_count others\\))]($style)";
              style = "fg:purple bg:#101817";
              symbol = "";
            };
            jj_change.disabled = true;
            jj_status = {
              format = "([ ](bg:#101817)$description)([ ](bg:#101817)$conflicted$hidden$immutable$added$copied$deleted$modified$renamed)";
              conflicted = "[!](fg:red bg:#101817)";
              description_empty = "[◌](bg:#101817)";
              description_present = "";
              hidden = "[󰈉](fg:black bg:#101817)";
              immutable = "[](fg:yellow bg:#101817)";
              added = "[+$count](fg:green bg:#101817)";
              copied = "[=$count](fg:black bg:#101817)";
              deleted = "[-$count](fg:red bg:#101817)";
              modified = "[±$count](fg:yellow bg:#101817)";
              renamed = "[»$count](fg:yellow bg:#101817)";
            };
            jj_metrics = {
              format = "([┊](fg:bright-black bg:#101817)[(+($added)L)]($added_style)[(-($deleted)L)]($deleted_style))";
              added_style = "fg:green bg:#101817";
              deleted_style = "fg:red bg:#101817";
            };

            # Right

            git_status = {
              disabled = true;
              style = "";
              format = "[$all_status$ahead_behind]($style)";
              conflicted = "[](fg:red)";
              ahead = "↑$count";
              behind = "↓$count";
              diverged = "↑$ahead_count↓$behind_count";
              untracked = "[?$count](fg:red)";
              stashed = "[\\$$count](fg:orange)";
              modified = "[±$count](fg:yellow)";
              staged = "[+$count](fg:green)";
              renamed = "[~$count](fg:yellow)";
              deleted = "[-$count](fg:red)";
            };
            c = {
              format = " [$symbol( $version)]($style)";
              style = "fg:blue";
              symbol = "";
            };
            dart = {
              format = " [$symbol( $version)]($style)";
              style = "fg:teal";
              symbol = "";
            };
            deno = {
              format = " [$symbol( $version)]($style)";
              style = "fg:text";
              symbol = "󰛦";
            };
            elixir = {
              format = " [$symbol( $version)]($style)";
              style = "fg:purple";
              symbol = "";
            };
            gleam = {
              format = " [$symbol( $version)]($style)";
              style = "fg:purple";
              symbol = "󰦥";
            };
            golang = {
              format = " [$symbol( $version)]($style)";
              style = "fg:blue";
              symbol = "󰟓";
            };
            haskell = {
              format = " [$symbol( $version)]($style)";
              style = "fg:purple";
              symbol = "";
            };
            java = {
              format = " [$symbol( $version)]($style)";
              style = "fg:blue";
              symbol = "";
            };
            kotlin = {
              format = " [$symbol( $version)]($style)";
              style = "fg:purple";
              symbol = "";
            };
            lua = {
              format = " [$symbol( $version)]($style)";
              style = "fg:blue";
              symbol = "";
            };
            nodejs = {
              format = " [$symbol( $version)]($style)";
              style = "fg:green";
              symbol = "";
            };
            ocaml = {
              format = " [$symbol( $version)]($style)";
              style = "fg:orange";
              symbol = "";
            };
            python = {
              format = " [$symbol( $version)]($style)";
              style = "fg:yellow";
              symbol = "";
            };
            rust = {
              format = " [$symbol( $version)]($style)";
              style = "fg:red";
              symbol = "";
            };
            zig = {
              format = " [$symbol( $version)]($style)";
              style = "fg:orange";
              symbol = "";
            };
          };
        }
      );
    };
}
