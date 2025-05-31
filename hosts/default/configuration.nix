# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "dragonfruit";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.nushell;
  users.users.emonadeo = {
    isNormalUser = true;
    description = "Emanuel Pilz";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = [ ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.fd
    pkgs.gcc
    pkgs.nushell
    pkgs.ripgrep
    pkgs.unzip
    pkgs.zip
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.dconf.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.gamemode.enable = true;

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "emonadeo";

  services.openssh.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  fonts = {
    packages = [
      inputs.apple-emoji.packages.x86_64-linux.default
      pkgs.commit-mono # neutral
      pkgs.departure-mono # bitmap
      pkgs.fragment-mono # helvetica
      pkgs.geist-font
      pkgs.inter
      pkgs.ipaexfont
      pkgs.jetbrains-mono
      pkgs.lora
      pkgs.maple-mono.variable # rounded
      pkgs.nerd-fonts.symbols-only
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-cjk-serif
      pkgs.source-serif
    ];
    enableDefaultPackages = false;
    fontconfig = {
      enable = true;
      # TODO: Clean up and move to single source of truth that is
      # shared between fontconfig, ghostty and neovide
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <match target="pattern">
            <test qual="any" name="family"><string>Segoe UI</string></test>
            <edit name="family" mode="assign" binding="same"><string>Maple Mono</string></edit>
          </match>
          <match target="font">
            <test name="family" compare="eq" ignore-blanks="true">
              <string>Maple Mono</string>
            </test>
            <edit name="fontfeatures" mode="append">
              <string>calt off</string>
              <string>cv01 on</string>
              <string>cv02 on</string>
              <string>cv03 off</string>
              <string>cv04 off</string>
              <string>cv05 on</string>
              <string>cv06 off</string>
              <string>cv07 off</string>
              <string>cv08 on</string>
              <string>cv61 on</string>
              <string>cv62 off</string>
              <string>cv63 off</string>
              <string>cv64 off</string>
              <string>cv65 off</string>
              <string>cv31 on</string>
              <string>cv32 off</string>
              <string>cv33 on</string>
              <string>cv34 on</string>
              <string>cv35 on</string>
              <string>cv36 on</string>
              <string>cv37 off</string>
              <string>cv38 on</string>
              <string>cv39 off</string>
              <string>cv40 off</string>
              <string>cv41 on</string>
            </edit>
          </match>
        </fontconfig>
      '';
      defaultFonts = {
        emoji = [ "Apple Color Emoji" ];
        serif = [
          "Maple Mono"
          # "Lora"
          "Source Serif"
          "IPAexMincho"
          "Noto Serif"
          "Noto Serif CJK"
        ];
        sansSerif = [
          "Maple Mono"
          # "Inter"
          "IPAexGothic"
          "Noto Sans"
          "Noto Sans CJK"
        ];
        monospace = [
          "Maple Mono"
          # "Commit Mono"
          "Symbols Nerd Fonts"
        ];
      };
      hinting = {
        enable = true;
      };
      subpixel = {
        rgba = "rgb";
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
