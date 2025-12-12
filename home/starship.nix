{ inputs, pkgs, ... }:

let
  tomlFormat = pkgs.formats.toml { };
  bgColor = {
    TrueColor = {
      r = 16;
      g = 24;
      b = 23;
    };
  };
in
{
  programs.starship = {
    enable = true;
    settings = {
      line_break.disabled = true;
      format = inputs.nixpkgs.lib.concatStrings [
        "$nix_shell"
        "$directory"
        "$\{custom.jj\}"
        "[](fg:#101817)"
        "[ ]()"
      ];
      right_format = inputs.nixpkgs.lib.concatStrings [
        "$\{custom.jj_status\}"
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

      nix_shell = {
        format = "[ $symbol $name ]($style)[](fg:blue bg:#101817)";
        style = "fg:#101817 bg:blue";
        symbol = "";
        heuristic = true;
      };
      directory = {
        format = "[ $path]($style)[$read_only]($read_only_style)[ ]($style)";
        style = "bold fg:blue bg:#101817";
        read_only = " ";
        read_only_style = "bold fg:red bg:#101817";
      };
      # `git_branch` is currently unused (btw I use jujutsu)
      git_branch = {
        format = "[]($style fg:bright-black)[ $symbol $branch(:$remote_branch) ]($style)";
        style = "fg:green bg:#101817";
        symbol = "";
      };
      custom.jj = {
        format = "[]($style fg:bright-black)[ $output ]($style)";
        style = "fg:green bg:#101817";
        detect_folders = [ ".jj" ];
        shell = [
          "nu"
          "-c"
        ];
        command = "${
          inputs.starship-jj.packages.${pkgs.system}.default
        }/bin/starship-jj --ignore-working-copy starship prompt --starship-config ${
          tomlFormat.generate "starship-jj.toml" {
            module_separator = " ";
            reset_color = false;
            bookmarks = {
              search_depth = 100;
              exclude = [ ];
            };
            module = [
              {
                type = "Symbol";
                symbol = "";
                color = "Green";
                bg_color = bgColor;
              }
              {
                type = "Bookmarks";
                separator = " ";
                behind_symbol = "↘";
                surround_with_quotes = false;
                ignore_empty_commits = "None";
                bg_color = bgColor;
              }
              {
                type = "Commit";
                previous_message_symbol = "↗";
                max_length = 24;
                show_previous_if_empty = false;
                empty_text = "(no description set)";
                surround_with_quotes = false;
                bg_color = bgColor;
                non_unique = {
                  color = "Black";
                  bg_color = bgColor;
                };
              }
            ];
          }
        }";
        ignore_timeout = true;
        use_stdin = false;
      };

      # Right

      # `git_status` is currently unused (btw I use jujutsu)
      git_status = {
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
      custom.jj_status = {
        detect_folders = [ ".jj" ];
        format = " [$output]($style)";
        shell = [
          "nu"
          "-c"
        ];
        command = "${
          inputs.starship-jj.packages.${pkgs.system}.default
        }/bin/starship-jj --ignore-working-copy starship prompt --starship-config ${
          tomlFormat.generate "starship-jj.toml" {
            module_separator = " ";
            reset_color = false;
            bookmarks = {
              search_depth = 100;
              exclude = [ ];
            };
            module = [
              {
                type = "State";
                separator = " ";
                conflict = {
                  disabled = false;
                  text = "";
                  color = "Red";
                };
                divergent = {
                  disabled = false;
                  text = "";
                  color = "Cyan";
                };
                empty = {
                  disabled = false;
                  text = "";
                  color = "Yellow";
                };
                immutable = {
                  disabled = false;
                  text = "";
                  color = "Yellow";
                };
                hidden = {
                  disabled = false;
                  text = "󰈉";
                  color = "Yellow";
                };
              }
              {
                type = "Metrics";
                template = "{removed}{changed}{added}";
                hide_if_empty = false;
                changed_files = {
                  prefix = "±";
                  suffix = "";
                  color = "Yellow";
                };
                added_lines = {
                  prefix = "+";
                  suffix = "";
                  color = "Green";
                };
                removed_lines = {
                  prefix = "-";
                  suffix = "";
                  color = "Red";
                };
              }
            ];
          }
        }";
        ignore_timeout = true;
        use_stdin = false;
      };
      c = {
        format = " [$symbol $version]($style)";
        style = "fg:blue";
        symbol = "";
      };
      dart = {
        format = " [$symbol $version]($style)";
        style = "fg:teal";
        symbol = "";
      };
      deno = {
        format = " [$symbol $version]($style)";
        style = "fg:text";
        symbol = "󰛦";
      };
      elixir = {
        format = " [$symbol $version]($style)";
        style = "fg:purple";
        symbol = "";
      };
      gleam = {
        format = " [$symbol $version]($style)";
        style = "fg:purple";
        symbol = "󰦥";
      };
      golang = {
        format = " [$symbol $version]($style)";
        style = "fg:blue";
        symbol = "󰟓";
      };
      haskell = {
        format = " [$symbol $version]($style)";
        style = "fg:purple";
        symbol = "";
      };
      java = {
        format = " [$symbol $version]($style)";
        style = "fg:blue";
        symbol = "";
      };
      kotlin = {
        format = " [$symbol $version]($style)";
        style = "fg:purple";
        symbol = "";
      };
      lua = {
        format = " [$symbol $version]($style)";
        style = "fg:blue";
        symbol = "";
      };
      nodejs = {
        format = " [$symbol $version]($style)";
        style = "fg:green";
        symbol = "";
      };
      ocaml = {
        format = " [$symbol $version]($style)";
        style = "fg:orange";
        symbol = "";
      };
      python = {
        format = " [$symbol $version]($style)";
        style = "fg:yellow";
        symbol = "";
      };
      rust = {
        format = " [$symbol $version]($style)";
        style = "fg:red";
        symbol = "";
      };
      zig = {
        format = " [$symbol $version]($style)";
        style = "fg:orange";
        symbol = "";
      };
    };
  };
}
