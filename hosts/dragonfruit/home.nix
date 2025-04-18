{ config, pkgs, inputs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "emonadeo";
  home.homeDirectory = "/home/emonadeo";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    inputs.zen-browser.packages.x86_64-linux.default
    pkgs.discord
    pkgs.protonup
    pkgs.python312
    pkgs.telegram-desktop
    pkgs.spotify
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/emonadeo/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
    
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.nushell.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Emanuel Pilz";
    userEmail = "emonadeo@gmail.com";
  };

  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "[](fg:crust)"
        "[ ]()"
      ];
      right_format = lib.concatStrings [
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
        symbol = "" ;
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

  programs.tofi = {
    enable = true;
    settings = {
      # Fonts
      font = "monospace";
      font-size = 16;

      # Text theming
      text-color = "#cdd6f4";
      prompt-color = "#f38ba8";
      selection-color = "#f9e2af";

      # Text cursor theme
      text-cursor-style = "block";

      # Text layout
      prompt-text = "> ";
      prompt-padding = 0;
      horizontal = false;

      # Window theming
      width = 1280;
      height = 720;
      background-color = "#1e1e2e";
      outline-width = 0;
      outline-color = "#000000";
      border-width = 0;
      border-color = "#000000";
      corner-radius = 8;
      padding-top = 16;
      padding-right = 16;
      padding-bottom = 16;
      padding-left = 16;
      clip-to-padding = true;
      scale = false;

      # Window positioning
      anchor = "center";
      margin-top = 8;
      margin-right = 8;
      margin-bottom = 8;
      margin-left = 8;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      bind = [
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, T, exec, $terminal"
        "$mod, F, fullscreen"
        "$mod, RIGHT, workspace, +1"
        "$mod, LEFT, workspace, -1"
        "$mod SHIFT, RIGHT, movetoworkspace, +1"
        "$mod SHIFT, LEFT, movetoworkspace, -1"
        "$mod, SPACE, exec, tofi-drun --drun-launch=true"
      ];
      monitor = [
       "HDMI-A-1, preferred, 0x0, auto"
       "DP-2, preferred, auto-right, auto"
      ];
      xwayland = {
        force_zero_scaling = true;
      };
    };
  };
}
