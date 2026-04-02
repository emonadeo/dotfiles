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
        self.darwinModules.shell
        self.sharedModules.nix
        self.sharedModules.time
      ];

      nixpkgs.hostPlatform = "aarch64-darwin";

      users = {
        users.${self.lib.user.handle} = {
          home = /Users/${self.lib.user.handle};
          description = self.lib.user.name;
        };
      };

      # TODO: Remove once obsolete
      system.primaryUser = self.lib.user.handle;

      system.stateVersion = 6;
    };
}
