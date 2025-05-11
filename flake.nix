{
  inputs = {
    apple-emoji = {
      url = "github:samuelngs/apple-emoji-linux";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nvim = {
      url = "git+file:nvim";
      flake = false;
    };
    # TODO: Migrate to official flake once available
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      lix,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        dragonfruit = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            lib = nixpkgs.lib;
          };
          modules = [
            lix.nixosModules.default
            ./hosts/dragonfruit/configuration.nix
          ];
        };
      };
    };
}
