{
  config,
  pkgs,
  inputs,
  ...
}:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      (import ../overlays/spotify.nix { inherit inputs; })
    ];
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "emonadeo";
    homeDirectory = "/home/emonadeo";
    # BUG: This does not work with nushell
    # (https://github.com/nix-community/home-manager/issues/4313)
    sessionVariables = { };
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 24;
    };
    packages = [
      inputs.zen-browser.packages.${pkgs.system}.default
      pkgs.bat
      pkgs.bottles
      pkgs.delta
      pkgs.deno
      pkgs.element-desktop
      pkgs.lutris
      pkgs.neovide
      pkgs.proton-pass
      pkgs.rofi-wayland
      pkgs.spotify
      pkgs.telegram-desktop
      pkgs.vesktop
      pkgs.wl-clipboard
      pkgs.xdg-utils

      # Screenshot
      pkgs.slurp
      pkgs.grim

      # Gaming
      pkgs.protonup

      # Languages & Language Servers
      pkgs.astro-language-server
      pkgs.biome
      pkgs.cargo
      pkgs.emmet-language-server
      pkgs.gleam
      pkgs.go
      pkgs.just
      pkgs.lua-language-server
      pkgs.nil
      pkgs.nixfmt-rfc-style
      pkgs.nodejs
      pkgs.python312
      pkgs.ruff
      pkgs.rust-analyzer
      pkgs.rustc
      pkgs.rustfmt
      pkgs.stylua
      pkgs.taplo
      pkgs.vscode-langservers-extracted
      pkgs.vtsls
    ];
    file = {
      ".local/share/icons/macos" = {
        recursive = true;
        source = pkgs.fetchzip {
          name = "hyprcursor_macos";
          url = "https://github.com/driedpampas/macOS-hyprcursor/releases/download/v1/macOS.Hyprcursor.SVG.tar.gz";
          hash = "sha256-Iv7DCpI0LKLljyz63V01Q9EWnx7jZRPOJiX78fJtQgg=";
        };
      };

      ".config/neovide/config.toml" = {
        source = ./neovide.toml;
      };

      ".config/nvim" = {
        recursive = true;
        source = inputs.nvim;
      };
    };

  };

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin";
      package = pkgs.catppuccin-gtk;
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    chromium = {
      enable = true;
      commandLineArgs = [ "--ozone-platform=wayland" ];
      extensions = [
        # DeArrow
        { id = "enamippconapkdmgfgjchkhakpfinmaj"; }
        # Proton Pass
        { id = "ghmbeldphafepmbegfdlkpapadhbakde"; }
        # SponsorBlock
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
        # uBlock Origin
        { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; }
      ];
    };
    feh = {
      enable = true;
      buttons = {
        prev_img = "";
        next_img = "";
        zoom_in = 4;
        zoom_out = 5;
      };
    };
    nushell = {
      enable = true;
      environmentVariables = {
        EDITOR = "nvim";
        GDK_SCALE = 1.667;
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$env.HOME | path join \".steam/root/compatibilitytools.d\"";
        HYPRCURSOR_THEME = "macos";
        HYPRCURSOR_SIZE = 24;
      };
      configFile = {
        text = ''
          if (tty) == "/dev/tty1" { exec hyprland }
        '';
      };
    };
    ghostty = {
      enable = true;
      settings = {
        adjust-underline-thickness = 1;
        adjust-overline-thickness = 1;
        adjust-strikethrough-thickness = 1;
        background-opacity = 0.75;
        font-family = "Maple Mono";
        font-feature = [
          # basic ligatures
          "-calt"
          # character variants
          "+cv01" # remove gaps
          "+cv02" # alternative a
          "-cv03" # alternative i
          "-cv04" # alternative l1
          "+cv05" # alternative g
          "-cv06" # alternative i
          "-cv07" # alternative J
          "+cv08" # alternative r
          "+cv61" # alternative ,;
          "-cv62" # alternative ?
          "-cv63" # alternative left arrow (<=)
          "-cv64" # alternative left and right arrow (<= and >=)
          "-cv65" # alternative &
          # italic only
          "+cv31" # alternative a
          "-cv32" # alternative f
          "+cv33" # alternative i and j
          "+cv34" # alternative k
          "+cv35" # alternative l
          "+cv36" # alternative x
          "-cv37" # alternative y
          "+cv38" # alternative g
          "-cv39" # alternative i
          "-cv40" # alternative J
          "+cv41" # alternative r
        ];
        font-size = 13.5;
        # Use official `catppuccin-mocha.conf` instead of ported textmate theme
        theme = "catppuccin-mocha";
        window-padding-balance = true;
        window-padding-x = 16;
        window-padding-y = 16;
        window-inherit-working-directory = true;
      };
    };
    git = {
      enable = true;
      lfs.enable = true;
      userName = "Emanuel Pilz";
      userEmail = "emonadeo@gmail.com";
    };
    qutebrowser = {
      enable = true;
      keyBindings = { };
    };
    starship = {
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
    tofi = {
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
        outline-width = 1;
        outline-color = "#ffffff";
        border-width = 1;
        border-color = "#ff00ff";
        corner-radius = 8;
        padding-top = 16;
        padding-right = 16;
        padding-bottom = 16;
        padding-left = 16;
        clip-to-padding = true;
        scale = true;

        # Window positioning
        anchor = "center";
        margin-top = 8;
        margin-right = 8;
        margin-bottom = 8;
        margin-left = 8;
      };
    };
    yazi = {
      enable = true;
      enableNushellIntegration = true;
      initLua = ''
        require("full-border"):setup({ type = ui.Border.ROUNDED })
        require("git"):setup()
        require("starship"):setup()
      '';
      plugins = {
        full-border = pkgs.yaziPlugins.full-border;
        git = pkgs.yaziPlugins.git;
        starship = pkgs.yaziPlugins.starship;
      };
      flavors = {
        catppuccin-latte = inputs.yazi-flavors + /catppuccin-latte.yazi;
        catppuccin-mocha = inputs.yazi-flavors + /catppuccin-mocha.yazi;
      };
      theme = {
        flavor = {
          dark = "catppuccin-mocha";
          light = "catppuccin-latte";
        };
      };
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [ "${../wallpapers/camille-unknown_the-cave_2x.png}" ];
      wallpaper = [ ", ${../wallpapers/camille-unknown_the-cave_2x.png}" ];
    };
  };

  services.playerctld.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      bind = [
        "$mod, Q, killactive"
        "$mod SHIFT, Q, exit"
        "$mod, T, exec, $terminal"
        "$mod, P, exec, nu -c \"slurp | grim -g \\$in - | wl-copy\""
        "$mod SHIFT, P, exec, nu -c \"grim -o (hyprctl -j activeworkspace | from json | get monitor) - | wl-copy\""
        "$mod, F, fullscreen"
        "$mod SHIFT, F, togglefloating"
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        "$mod, NEXT, focusmonitor, +1"
        "$mod, PRIOR, focusmonitor, -1"
        "$mod SHIFT, NEXT, movecurrentworkspacetomonitor, +1"
        "$mod SHIFT, PRIOR, movecurrentworkspacetomonitor, -1"
        "$mod SHIFT, HOME, movecurrentworkspacetomonitor, +1"
        "$mod SHIFT, END, movecurrentworkspacetomonitor, -1"
        "$mod, SPACE, exec, tofi-drun --drun-launch=true"
        "$mod SHIFT, SPACE, exec, rofi -show drun"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ];
      decoration = {
        shadow.enabled = false;
        rounding = 6;
        blur = {
          enabled = true;
          # single pass looks poop
          # total size = passes * size
          # 8 = 1 * 8 = 2 * 4
          passes = 2;
          size = 4;
        };
      };
      general = {
        "col.inactive_border" = "0xff313244";
        "col.active_border" = "0xffcdd6f4";
        border_size = 2;
        gaps_in = 8;
        gaps_out = 16;
      };
      input = {
        kb_layout = "eu";
        accel_profile = "flat";
        force_no_accel = true;
      };
      # Prevent color picker and screenshot tools to capture selection borders
      layerrule = [
        "noanim, hyprpicker"
        "noanim, selection"
      ];
      monitor = [
        "HDMI-A-1, preferred, 0x0, 1.667"
        "DP-2, preferred, auto-right, 1.667"
      ];
      xwayland = {
        force_zero_scaling = true;
      };
      misc = {
        background_color = "0x000000";
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
      };
      debug = {
        full_cm_proto = true;
      };
    };
  };

  xresources = {
    path = "${config.home.homeDirectory}/.Xdefaults";
    properties = {
      "Xft.dpi" = 168;
      "Xft.autohint" = 0;
      "Xft.lcdfilter" = "lcddefault";
      "Xft.hintstyle" = "hintfull";
      "Xft.hinting" = 1;
      "Xft.antialias" = 1;
      "Xft.rgba" = "rgb";
    };
  };

  xdg = {
    enable = true;
    desktopEntries = {
      nvim = {
        name = "Neovim";
        exec = "";
        noDisplay = true;
      };
      nixos-manual = {
        name = "NixOS Manual";
        exec = "";
        noDisplay = true;
      };
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "image/bmp" = "feh.desktop";
        "image/jpeg" = "feh.desktop";
        "image/png" = "feh.desktop";
        "image/pnm" = "feh.desktop";
        "image/tiff" = "feh.desktop";
        "image/webp" = "feh.desktop";
        "application/pdf" = "zen-beta.desktop";
        "application/xhtml+xml" = "zen-beta.desktop";
        "text/html" = "zen-beta.desktop";
        "text/xml" = "zen-beta.desktop";
        "x-scheme-handler/http" = "zen-beta.desktop";
        "x-scheme-handler/https" = "zen-beta.desktop";
      };
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.
}
