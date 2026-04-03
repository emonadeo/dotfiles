{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrappers-b.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers-l.url = "github:lassulus/wrappers";

    affinity = {
      url = "github:mrshmllow/affinity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-emoji = {
      url = "github:samuelngs/apple-emoji-linux/v1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-ghostty = {
      url = "github:catppuccin/ghostty";
      flake = false;
    };
    ghostty-cursor-shaders = {
      url = "github:sahaj-b/ghostty-cursor-shaders";
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
    # NUR repository that provides `helium`.
    ev357 = {
      url = "github:Ev357/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim = {
      url = "github:emonadeo/nvim";
      flake = false;
    };
    spotx = {
      url = "github:SpotX-Official/SpotX-Bash";
      flake = false;
    };
    starship-jj = {
      url = "gitlab:lanastara_foss/starship-jj";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    paneru = {
      url = "github:karinushka/paneru";
      inputs.nixpkgs.follows = "nixpkgs";
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

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        imports = [ (inputs.import-tree ./modules) ];

        # TODO: Should this be defined elsewhere?
        options.flake = {
          lib = lib.mkOption { };
          darwinModules = lib.mkOption { };
          sharedModules = lib.mkOption { };
        };

        config = {
          systems = [
            "aarch64-darwin"
            "aarch64-linux"
            "x86_64-darwin"
            "x86_64-linux"
          ];
        };
      }
    );
}
