{ inputs, ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      format = inputs.nixpkgs.lib.concatStrings [
        "$directory"
        "$git_branch"
        "[](fg:crust)"
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
      palette = "catppuccin";
      palettes.catppuccin = {
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        surface_1 = "#45475a";
        crust = "#11111b";
        base = "#1e1e2e";
      };
      directory = {
        format = "[ $path]($style)[$read_only]($read_only_style)[ ]($style)";
        style = "bold fg:blue bg:crust";
        read_only = " ";
        read_only_style = "bold fg:red bg:crust";
      };
      git_branch = {
        format = "[]($style fg:surface_1)[ $symbol $branch(:$remote_branch) ]($style)";
        style = "fg:green bg:crust";
        symbol = "";
      };
      git_status = {
        style = "";
        format = "[$all_status$ahead_behind]($style)";
        conflicted = "[](fg:red)";
        ahead = "↑$count";
        behind = "↓$count";
        diverged = "↑$ahead_count↓$behind_count";
        untracked = "[?$count](fg:red)";
        stashed = "[\\$$count](fg:peach)";
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
        style = "fg:mauve";
        symbol = "";
      };
      gleam = {
        format = " [$symbol $version]($style)";
        style = "fg:mauve";
        symbol = "󰦥";
      };
      golang = {
        format = " [$symbol $version]($style)";
        style = "fg:blue";
        symbol = "󰟓";
      };
      haskell = {
        format = " [$symbol $version]($style)";
        style = "fg:lavender";
        symbol = "";
      };
      java = {
        format = " [$symbol $version]($style)";
        style = "fg:blue";
        symbol = "";
      };
      kotlin = {
        format = " [$symbol $version]($style)";
        style = "fg:mauve";
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
        style = "fg:peach";
        symbol = "";
      };
      python = {
        format = " [$symbol $version]($style)";
        style = "fg:yellow";
        symbol = "";
      };
      rust = {
        format = " [$symbol $version]($style)";
        style = "fg:maroon";
        symbol = "";
      };
      zig = {
        format = " [$symbol $version]($style)";
        style = "fg:peach";
        symbol = "";
      };
    };
  };
}
