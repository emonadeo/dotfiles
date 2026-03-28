{ inputs, self, ... }:
{
  flake.darwinConfigurations.plex = inputs.nix-darwin.lib.darwinSystem {
    modules = [ self.darwinModules.plex ];
  };

  flake.darwinModules.plex =
    { pkgs, ... }:
    {
      imports = [
        self.darwinModules.paneru
        self.sharedModules.nix
      ];

      nixpkgs.hostPlatform = "aarch64-darwin";

      nix-homebrew = {
        enable = true;
        user = "emonadeo";
        autoMigrate = true;
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
        };
      };

      environment = {
        shellInit = self.lib.shellInitNushell;
        # TODO: Single source of truth for all devices
        systemPackages = [
          pkgs.imagemagick
          pkgs.openssl
          pkgs.ripgrep
          pkgs.unzip
          pkgs.yq-go
          pkgs.zip
        ];
      };

      users = {
        users.emonadeo = {
          home = /Users/emonadeo;
          description = self.lib.user.name;
          packages = [
            pkgs.mise
          ];
        };
      };

      homebrew = {
        enable = true;
        brews = [ ];
        casks = [
          "affinity"
          "element"
          "helium-browser"
          "steam"
          "telegram"
        ];
      };

      # TODO: Remove once obsolete
      system.primaryUser = "emonadeo";

      system.stateVersion = 6;
    };
}
