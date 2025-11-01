{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
    ./niri.nix
    ./bitwarden.nix
    ./chromium.nix
    ./cursor/default.nix
    ./darkman.nix
    ./feh.nix
    ./fuzzel.nix
    ./ghostty.nix
    ./jujutsu.nix
    ./mako.nix
    ./neovide/default.nix
    ./neovim.nix
    ./nushell.nix
    ./qutebrowser.nix
    ./spotify.nix
    ./starship.nix
    ./waybar.nix
    ./yazi.nix
    ./zen_browser.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage.
  home = {
    username = "emonadeo";
    homeDirectory = "/home/emonadeo";
    sessionVariables = {
      TERMINAL = "ghostty";
      EDITOR = "nvim";
      GDK_SCALE = 1.667;
      HYPRCURSOR_THEME = "macos";
      HYPRCURSOR_SIZE = 24;
      QT_QPA_PLATFORM = "wayland";
      NIXOS_OZONE_WL = 1;
    };
    packages = [
      pkgs.blender
      pkgs.bottles
      pkgs.element-desktop
      pkgs.lutris
      pkgs.proton-pass
      pkgs.signal-desktop
      pkgs.teamspeak6-client
      pkgs.telegram-desktop
      pkgs.vesktop
      pkgs.wl-clipboard
      pkgs.xdg-utils

      # Gaming
      (pkgs.prismlauncher.override {
        jdks = [
          pkgs.jdk21
          pkgs.graalvmPackages.graalvm-ce
        ];
      })

      pkgs.devenv

      # Languages & Language Servers
      pkgs.astro-language-server
      pkgs.biome
      pkgs.cargo
      pkgs.dprint
      pkgs.emmet-language-server
      pkgs.gleam
      pkgs.go
      pkgs.gopls
      pkgs.just
      pkgs.lua-language-server
      pkgs.nil
      pkgs.nixfmt-rfc-style
      pkgs.nodejs
      pkgs.openssl
      pkgs.python312
      pkgs.ruff
      pkgs.rust-analyzer
      pkgs.rustc
      pkgs.rustfmt
      pkgs.stylua
      pkgs.taplo
      pkgs.vscode-langservers-extracted
      pkgs.vtsls
      pkgs.zig

      inputs.affinity.packages.${pkgs.system}.default
    ];
  };

  gtk.enable = true;

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
          name = "Emanuel Pilz";
          email = "emonadeo@gmail.com";
        };
      };
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
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
        };
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
