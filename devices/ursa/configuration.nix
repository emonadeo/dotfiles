# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  fonts = import ../../fonts.nix { inherit pkgs; };
in
{
  imports = [
    inputs.home-manager.nixosModules.default
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    ./hardware-configuration.nix
    ../../nixos/zsh.nix
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.garnix.io"
        "https://devenv.cachix.org"
        "https://niri.cachix.org"
      ];
      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
    };
    gc.automatic = true;
    optimise.automatic = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "ursa";
    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openvpn ];
    };
    interfaces = {
      enp11s0.useDHCP = true;
      wlp10s0.useDHCP = true;
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs fonts; };
    users = {
      "emonadeo" = import ../../home/default.nix;
    };
  };

  nixpkgs = {
    overlays = [
      inputs.niri.overlays.niri
      # Patch Spotify with SpotX-Bash
      (import ../../overlays/spotify.nix { inherit inputs lib pkgs; })
    ];

    config = {
      cudaSupport = false;
      rocmSupport = true;
      allowUnfree = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users.emonadeo = {
      isNormalUser = true;
      description = "Emanuel Pilz";
      extraGroups = [
        "networkmanager"
        "wheel" # Enable `sudo`
      ];
      packages = [ ];
    };
  };

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
    # BUG:
    # <https://discourse.nixos.org/t/unable-to-activate-gamescope-capsysnice-option/37843/10>
    # <https://github.com/NixOS/nixpkgs/issues/351516>
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    gamescopeSession = {
      enable = true;
      args = [
        "--adaptive-sync" # VRR support
        "-W 3840"
        "-H 2160"
        "-r 60"
        "--steam"
      ];
      steamArgs = [
        "-pipewire-dmabuf"
        "-gamepadui"
      ];
    };
  };

  # SSD maintenance
  services.fstrim.enable = true;
  services.fwupd.enable = true;

  services.getty.autologinUser = "emonadeo";

  services.openssh.enable = true;

  # Sound
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  environment = {
    pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];
    systemPackages = [
      pkgs.ripgrep
      pkgs.unzip
      pkgs.zip
    ];
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    checkReversePath = false;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  fonts = {
    enableDefaultPackages = false;
    packages = [
      inputs.apple-emoji.packages.x86_64-linux.default
      pkgs.commit-mono # neutral
      pkgs.departure-mono # bitmap
      pkgs.fragment-mono # helvetica
      pkgs.inter
      pkgs.ipaexfont
      pkgs.lora
      pkgs.maple-mono.variable
      pkgs.nerd-fonts.symbols-only
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-cjk-serif
      pkgs.source-serif
    ];
    fontconfig = {
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
              <string>${fonts.maple-mono.name}</string>
            </test>
            <edit name="fontfeatures" mode="append">
              ${fonts.maple-mono.features.xml}
            </edit>
          </match>
        </fontconfig>
      '';
      defaultFonts = {
        emoji = [ "Apple Color Emoji" ];
        serif = [
          fonts.maple-mono.name
          # "Lora"
          "IPAexMincho"
          "Noto Serif"
          "Noto Serif CJK"
        ];
        sansSerif = [
          fonts.maple-mono.name
          # "Inter"
          "IPAexGothic"
          "Noto Sans"
          "Noto Sans CJK"
        ];
        monospace = [
          fonts.maple-mono.name
          # "Commit Mono"
          "Symbols Nerd Font"
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

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    keyboard.qmk.enable = true;
    steam-hardware.enable = true;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
