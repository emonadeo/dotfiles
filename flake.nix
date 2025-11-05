{
  inputs = {
    self.submodules = true;
    affinity = {
      url = "github:mrshmllow/affinity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-emoji = {
      url = "github:samuelngs/apple-emoji-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-ghostty = {
      url = "github:catppuccin/ghostty";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
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
      url = ./home/nvim;
      flake = false;
    };
    spotx = {
      url = "github:SpotX-Official/SpotX-Bash";
      flake = false;
    };
    # TODO: Use Stylix
    # stylix = {
    #  url = "github:nix-community/stylix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
    tgt = {
      url = "github:FedericoBruzzone/tgt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # FIXME: Not working with ghostty
    # xdg-desktop-portal-termfilepickers = {
    #   url = "github:Guekka/xdg-desktop-portal-termfilepickers";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
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
    darwinConfigurations = {
      plex = inputs.nix-darwin.lib.darwinSystem {
        modules = [ ./devices/plex/configuration.nix ];
        specialArgs = { inherit inputs; };
      };
    };
    nixosConfigurations = {
      ursa = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./devices/ursa/configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.niri.nixosModules.niri
          # BUG: Stylix is incompatible with `lazy.nvim`
          # Uncomment once Neovim 0.12 is released
          # See https://github.com/nix-community/stylix/issues/505
          # inputs.stylix.nixosModules.stylix
          # ./nixos/stylix.nix
        ];
      };
    };
  };
}
