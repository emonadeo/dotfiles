{
  inputs = {
    # TODO: Setup in steam post install or similarly
    # adwaita-for-steam = {
    #   url = "github:tkashkin/Adwaita-for-Steam";
    #   flake = false;
    # };
    apple-emoji = {
      # FIXME: Move back to "github:samuelngs/apple-emoji-linux"
      # once https://github.com/samuelngs/apple-emoji-linux/pull/69 is resolved.
      url = "github:typedrat/apple-emoji-linux/fix-flake-on-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO: Remove once v0.1.9 is released.
    # This is only used for obtaining `command-not-found.nu`, which isn't in v0.1.8.
    nix-index = {
      url = "github:nix-community/nix-index";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nvim = {
      url = "git+file:nvim";
      flake = false;
    };
    spotx = {
      url = "github:SpotX-Official/SpotX-Bash";
      flake = false;
    };
    yazi-flavors = {
      url = "github:yazi-rs/flavors";
      flake = false;
    };
    # TODO: Migrate to official flake once available
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations = {
      default = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          lib = inputs.nixpkgs.lib; # TODO: Consider removing this
        };
        modules = [
          inputs.lix.nixosModules.default
          inputs.home-manager.nixosModules.default
          ./hosts/default/configuration.nix
          {
            home-manager = {
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs; };
              users = {
                "emonadeo" = import ./home;
              };
            };
          }
        ];
      };
    };
  };
}
