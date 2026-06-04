{
  inputs,
  moduleWithSystem,
  self,
  ...
}:
{
  flake.darwinConfigurations.plex = inputs.nix-darwin.lib.darwinSystem {
    modules = [ self.darwinModules.plex ];
  };

  flake.darwinModules.plex = moduleWithSystem (
    _perSystem@{ self', ... }:
    _darwin@{ pkgs, ... }:
    {
      imports = [
        self.darwinModules.builder
        self.darwinModules.ghostty
        self.darwinModules.paneru
        self.darwinModules.shell
        self.sharedModules.nix
        self.sharedModules.time
      ];

      nixpkgs.hostPlatform = "aarch64-darwin";

      environment.systemPackages = [
        pkgs.cinny-desktop
        self'.packages.affinity
        self'.packages.helium
        self'.packages.mpv
        self'.packages.prismlauncher
        self'.packages.spotify
        self'.packages.vesktop
      ];

      # TODO: Remove once obsolete
      system.primaryUser = self.lib.user.handle;

      system.stateVersion = 6;
    }
  );
}
