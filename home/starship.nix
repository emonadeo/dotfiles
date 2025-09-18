{ inputs, ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      line_break.disabled = true;
      format = inputs.nixpkgs.lib.concatStrings [
        "$nix_shell"
        "$directory"
        "$git_branch"
        "[](fg:#101817)"
        "[ ]()"
      ];
      right_format = inputs.nixpkgs.lib.concatStrings [
        "$git_status"
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
      };
      directory = {
        format = "[ $path]($style)[$read_only]($read_only_style)[ ]($style)";
        style = "bold fg:blue bg:#101817";
        read_only = " ";
        read_only_style = "bold fg:red bg:#101817";
      };
      git_branch = {
        format = "[]($style fg:bright-black)[ $symbol $branch(:$remote_branch) ]($style)";
        style = "fg:green bg:#101817";
        symbol = "";
      };

      # Right

      git_status = {
        style = "";
        format = "[$all_status$ahead_behind]($style)";
        conflicted = "[](fg:red)";
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
