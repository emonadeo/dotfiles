{ inputs, self, ... }:
{
  flake.nixosConfigurations.ursa = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.ursa ];
  };

  flake.nixosModules.ursa =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        self.nixosModules.audio
        self.nixosModules.fonts
        self.nixosModules.gaming
        self.nixosModules.networking
        self.nixosModules.shell
        self.sharedModules.nix
        self.sharedModules.time
      ];

      nixpkgs = {
        hostPlatform = "x86_64-linux";
        config = {
          cudaSupport = false;
          rocmSupport = true;
          allowUnfree = true;
        };
      };

      hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

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
          systemd-boot.enable = true;
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
        # Use Zsh that spawns nushell as login shell.
        #
        # Ideally I would use nushell as my login shell, however this may cause
        # problems because nushell is not POSIX-compliant.
        #
        # See <https://github.com/NixOS/nixpkgs/issues/193880#issuecomment-2639344679>.
        # and <https://wiki.nixos.org/wiki/Fish#Setting_fish_as_default_shell>.
        # This also works around <https://github.com/nix-community/home-manager/issues/4313>.
        defaultUserShell = inputs.wrappers-b.zsh.wrap {
          zshrc.content = self.lib.shellInitNu;
        };
        users.${self.lib.user.handle} = {
          isNormalUser = true;
          description = self.lib.user.name;
          extraGroups = [
            "networkmanager"
            "wheel" # Enable `sudo`
          ];
        };
      };

      programs.dconf.enable = true;

      # SSD maintenance
      services.fstrim.enable = true;
      services.fwupd.enable = true;

      services.getty.autologinUser = self.lib.user.handle;

      environment = {
        pathsToLink = [
          "/share/xdg-desktop-portal"
          "/share/applications"
        ];
        # TODO: Single source of truth for all devices
        systemPackages = [
          inputs.affinity.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };

      hardware = {
        bluetooth = {
          enable = true;
          powerOnBoot = true;
        };
        keyboard.qmk.enable = true;
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
    };
}
