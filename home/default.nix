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
    ./element.nix
    ./feh.nix
    ./ghostty/default.nix
    ./jujutsu.nix
    ./lutris.nix
    ./mako.nix
    ./mpv.nix
    ./neovim.nix
    ./niri.nix
    ./nushell.nix
    ./paneru.nix
    ./qutebrowser.nix
    ./rofi.nix
    ./signal.nix
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
      TERMINAL = "${config.programs.ghostty.package}/bin/ghostty";
      GDK_SCALE = 1.667;
      # BUG: Obviously incorrect on darwin
      QT_QPA_PLATFORM = "wayland";
      NIXOS_OZONE_WL = 1;
    };
    packages = [
      pkgs.zathura
    ];
  };

  accounts.email.accounts = {
    gmail = {
      primary = true;
      enable = true;
      realName = "Emanuel Pilz";
      address = "emonadeo@gmail.com";
      # aliases = [ "emo.nadeo@gmail.com" ];
      flavor = "gmail.com";
      lieer.enable = true;
      meli.enable = true;
    };
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
        };
      };
    };
  };

  targets.darwin = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    # TODO: Revert from `copyApps` to `linkApps` once macOS' Spotlight supports symlinks
    # See <https://github.com/nix-community/home-manager/issues/1341>
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
