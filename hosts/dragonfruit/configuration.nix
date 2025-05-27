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
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
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

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users = {
      "emonadeo" = import ./home.nix;
    };
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  fonts = {
    packages = [
      inputs.apple-emoji.packages.x86_64-linux.default
      pkgs.geist-font
      pkgs.inter
      pkgs.ipaexfont
      pkgs.jetbrains-mono
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-cjk-serif
      pkgs.source-serif
    ];
    enableDefaultPackages = false;
    fontconfig = {
      enable = true;
      localConf = ''
        <match target="pattern">
          <test qual="any" name="family"><string>Segoe UI</string></test>
          <edit name="family" mode="assign" binding="same"><string>Inter</string></edit>
        </match>
      '';
      defaultFonts = {
        emoji = [ "Apple Color Emoji" ];
        serif = [
          "Source Serif"
          "IPAexMincho"
          "Noto Serif"
          "Noto Serif CJK"
        ];
        sansSerif = [
          "Inter"
          "IPAexGothic"
          "Noto Sans"
          "Noto Sans CJK"
        ];
        monospace = [ "Geist Mono" ];
      };
      hinting = {
        enable = true;
      };
      subpixel = {
        rgba = "rgb";
      };
    };
  };
}
