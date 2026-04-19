# TODO: Launch niri in tty1 (or using systemd? idk what the "proper" way is)
# programs.zsh.profileExtra = lib.mkIf config.programs.niri.enable ''
#   if [ "$(tty)" = "/dev/tty1" ]; then
#     # Undocumented flag `-l`.
#     # See <https://github.com/YaLTeR/niri/issues/1914>
#     exec niri-session -l
#   fi
# '';

{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake.nixosConfigurations.ursa = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.ursa ];
  };

  flake.nixosModules.ursa = moduleWithSystem (
    _perSystem@{ self', ... }:
    _nixos@{
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        # inputs.home-manager.nixosModules.home-manager
        inputs.nixos-hardware.nixosModules.common-pc-ssd
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-gpu-amd
        self.nixosModules.audio
        self.nixosModules.fonts
        self.nixosModules.gaming
        self.nixosModules.networking
        self.nixosModules.shell
        self.nixosModules.terminal
        self.nixosModules.xdg
        self.sharedModules.nix
        self.sharedModules.time
      ];

      # home-manager = {
      #   useGlobalPkgs = true;
      #   useUserPackages = true;
      #   users.emonadeo = {
      #     home.username = "emonadeo";
      #     home.homeDirectory = "/home/emonadeo";
      #     home.stateVersion = "25.11";
      #   };
      # };

      nixpkgs.hostPlatform = "x86_64-linux";

      environment.systemPackages = [
        pkgs.cinny-desktop
        pkgs.telegram-desktop
        self'.packages.helium
        self'.packages.mpv
        # TODO: Remove niri, run at start instead
        self'.packages.niri
        self'.packages.spotify
        self'.packages.vesktop
      ];

      boot = {
        initrd = {
          availableKernelModules = [
            "nvme"
            "ahci"
            "xhci_pci"
            "thunderbolt"
            "usb_storage"
            "usbhid"
            "sd_mod"
          ];
          kernelModules = [ ];
        };
        kernelModules = [ "kvm-amd" ];
        extraModulePackages = [ ];
        supportedFilesystems = [ "ntfs" ];
        loader = {
          systemd-boot = {
            enable = true;
            # Limit boot configurations to prevent /boot from filling up
            # See <https://github.com/NixOS/nixpkgs/issues/23926>
            configurationLimit = 32;
          };
          efi.canTouchEfiVariables = true;
        };
      };

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/ed8c4f00-9a90-4b81-82f0-d39c82e44a8e";
          fsType = "btrfs";
        };
        "/boot" = {
          device = "/dev/disk/by-uuid/3260-64E0";
          fsType = "vfat";
          options = [
            "fmask=0022"
            "dmask=0022"
          ];
        };
      };
      swapDevices = [
        { device = "/dev/disk/by-uuid/5f2dd594-5fd5-432a-bdc0-bea2ea38d926"; }
      ];

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";
      console = {
        font = "Lat2-Terminus16";
        useXkbConfig = true; # use xkb.options in tty.
      };

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users = {
        users.${self.lib.user.handle} = {
          isNormalUser = true;
          description = self.lib.user.name;
          extraGroups = [
            "networkmanager"
            "wheel" # Enable `sudo`
          ];
        };
      };

      # SSD maintenance
      services.fstrim.enable = true;
      services.fwupd.enable = true;

      services.getty.autologinUser = self.lib.user.handle;

      environment = {
        pathsToLink = [
          "/share/xdg-desktop-portal"
          "/share/applications"
        ];
      };

      hardware = {
        bluetooth = {
          enable = true;
          powerOnBoot = true;
        };
        keyboard.qmk.enable = true;
        enableRedistributableFirmware = true;
        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
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
  );
}
