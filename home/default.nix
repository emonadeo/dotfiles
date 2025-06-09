{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./cursor.nix
    ./hyprland.nix
    ./programs/chromium.nix
    ./programs/feh.nix
    ./programs/ghostty.nix
    ./programs/neovide.nix
    ./programs/neovim.nix
    ./programs/nushell.nix
    ./programs/qutebrowser.nix
    ./programs/spotify.nix
    ./programs/starship.nix
    ./programs/tgt.nix
    ./programs/tofi.nix
    ./programs/yazi.nix
    ./programs/zen_browser.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "emonadeo";
    homeDirectory = "/home/emonadeo";
    # BUG: This does not work with nushell
    # (https://github.com/nix-community/home-manager/issues/4313)
    sessionVariables = { };
    packages = [
      pkgs.bat
      pkgs.bottles
      pkgs.delta
      pkgs.deno
      pkgs.element-desktop
      pkgs.lutris
      pkgs.proton-pass
      pkgs.rofi-wayland
      pkgs.signal-desktop
      pkgs.teamspeak6-client
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
      pkgs.dprint
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
  };

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin";
      # TODO: Remove. `catppuccin-gtk` is discontinued.
      package = pkgs.catppuccin-gtk;
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
      userName = "Emanuel Pilz";
      userEmail = "emonadeo@gmail.com";
    };
  };

  services.playerctld.enable = true;

  xdg = {
    enable = true;
    desktopEntries = {
      # Remove NixOS manual
      nixos-manual = {
        name = "NixOS Manual";
        exec = "";
        noDisplay = true;
      };
    };
    mimeApps = {
      enable = true;
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
