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
        self.darwinModules.audio
        self.darwinModules.ghostty
        self.darwinModules.paneru
        self.darwinModules.shell
        self.sharedModules.nix
        self.sharedModules.time
      ];

      nixpkgs.hostPlatform = "aarch64-darwin";

      environment.systemPackages = [
        pkgs.audacity
        pkgs.cinny-desktop # Matrix client
        pkgs.croc
        pkgs.dolphin-emu # Gamecube/Wii Emulator
        pkgs.proton-vpn
        pkgs.typst
        pkgs.vesktop
        pkgs.zathura
        # BUG: Build failure
        # pkgs.zed-editor
        self'.packages.affinity
        self'.packages.helium
        self'.packages.librewolf
        self'.packages.mpv
        self'.packages.prismlauncher
        self'.packages.spotify
      ];

      # TODO: Remove once obsolete
      system.primaryUser = self.lib.user.handle;

      system.stateVersion = 6;
    }
  );
}
