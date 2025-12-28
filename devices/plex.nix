{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  fonts = import ../fonts.nix { inherit lib pkgs; };
in
{
  imports = [
    inputs.home-manager.darwinModules.default
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    overlays = [
      inputs.niri.overlays.niri
      # Patch Spotify with SpotX-Bash
      (import ../overlays/spotify.nix { inherit inputs lib pkgs; })
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    enable = true;
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://devenv.cachix.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
    gc.automatic = true;
    optimise.automatic = true;
  };

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
    systemPackages = [
      pkgs.ripgrep
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs fonts; };
    users = {
      "emonadeo" = import ../home/default.nix;
    };
  };

  users = {
    users.emonadeo = {
      home = /Users/emonadeo;
      description = "Emanuel Pilz";
      packages = [
        # BUG: <https://github.com/NixOS/nixpkgs/issues/461406>
        # pkgs.mise
      ];
    };
  };

  fonts.packages = [
    fonts.maple-mono.package
  ];

  homebrew = {
    enable = true;
    brews = [ ];
    casks = [
      "affinity"
      "helium-browser"
      "steam"
      "telegram"
    ];
  };

  # TODO: Remove once obsolete
  system.primaryUser = "emonadeo";

  system.stateVersion = 6;
}
