{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.niri.homeModules.niri
    inputs.nix-index-database.homeModules.nix-index
    inputs.paneru.homeModules.paneru
    ./affinity.nix
    ./blender.nix
    ./bitwarden.nix
    ./chromium.nix
    ./cursor/default.nix
    ./darkman.nix
    ./feh.nix
    ./ghostty/default.nix
    ./jujutsu.nix
    ./linux.nix
    ./lutris.nix
    ./mako.nix
    ./neovim.nix
    ./niri.nix
    ./nushell.nix
    ./paneru.nix
    ./qutebrowser.nix
    ./rofi.nix
    ./signal.nix
    ./spotify.nix
    ./starship.nix
    ./teamspeak.nix
    ./telegram.nix
    ./vesktop.nix
    ./yazi.nix
    ./zen_browser.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should manage.
  home = {
    username = "emonadeo";
    sessionVariables = {
      TERMINAL = config.programs.ghostty.package + /bin/ghostty;
      GDK_SCALE = 1.667;
      QT_QPA_PLATFORM = "wayland";
      NIXOS_OZONE_WL = 1;
    };
    packages = [
      pkgs.element-desktop
      pkgs.zathura

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
      pkgs.cargo
      pkgs.dprint
      pkgs.emmet-language-server
      pkgs.lua-language-server
      pkgs.nil # Nix
      pkgs.nixfmt
      pkgs.rust-analyzer
      pkgs.rustc
      pkgs.rustfmt
      pkgs.stylua # Lua
      pkgs.tombi # TOML
      pkgs.vscode-langservers-extracted
      pkgs.vtsls # TypeScript
    ]
    # Linux specific
    ++ lib.lists.optionals pkgs.stdenv.hostPlatform.isLinux [
      pkgs.eduvpn-client
      pkgs.heroic
      pkgs.ryubing
      pkgs.shipwright
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

  services.playerctld.enable = pkgs.stdenv.hostPlatform.isLinux;

  xdg = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    mimeApps = {
      enable = pkgs.stdenv.hostPlatform.isLinux;
    };
    portal = {
      enable = pkgs.stdenv.hostPlatform.isLinux;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = "gnome";
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
        };
      };
    };
  };

  targets.darwin = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    # TODO: Revert from `copyApps` to `linkApps` once macOS' Spotlight supports symlinks
    # See: <https://github.com/nix-community/home-manager/issues/1341>
    linkApps.enable = false;
    copyApps.enable = true;
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.
}
