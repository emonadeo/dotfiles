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
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nvim = {
      url = ./home/nvim;
      flake = false;
    };
    # TODO: Use Stylix
    # stylix = {
    #  url = "github:nix-community/stylix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
    # FIXME: Not working with ghostty
    # xdg-desktop-portal-termfilepickers = {
    #   url = "github:Guekka/xdg-desktop-portal-termfilepickers";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    paneru = {
      url = "github:karinushka/paneru";
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
    darwinModules = { };
    homeModules = { };
    nixosModules = { };
    darwinConfigurations = {
      # Apple MacBook Pro 14" (M1 Pro)
      plex = inputs.nix-darwin.lib.darwinSystem {
        modules = [ ./devices/plex/configuration.nix ];
        specialArgs = { inherit inputs; };
      };
    };
    nixosConfigurations = {
      # <https://de.pcpartpicker.com/user/Emonadeo/saved/QJBCrH>
      # CPU: AMD Ryzen 7 9800X3D
      # GPU: AMD Radeon RX7900 GRE
      ursa = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./devices/ursa/configuration.nix
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
