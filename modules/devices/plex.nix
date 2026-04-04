{
  inputs,
  self,
  withSystem,
  ...
}:
{
  flake.darwinConfigurations.plex = inputs.nix-darwin.lib.darwinSystem {
    modules = [ self.darwinModules.plex ];
  };

  flake.darwinModules.plex =
    { pkgs, ... }:
    {
      imports = [
        self.darwinModules.fonts
        self.darwinModules.paneru
        self.darwinModules.shell
        self.sharedModules.nix
        self.sharedModules.time
      ];

      nixpkgs.hostPlatform = "aarch64-darwin";

      environment.systemPackages = withSystem pkgs.stdenv.hostPlatform.system (
        { self', ... }:
        [
          self'.packages.ghostty-with-env
          self'.packages.helium
          self'.packages.mpv
          self'.packages.spotify
          self'.packages.vesktop
        ]
      );

      system.stateVersion = 6;
    };
}
