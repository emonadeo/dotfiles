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
    # BUG: v2 is broken
    apple-emoji-ttf = {
      url = "github:samuelngs/apple-emoji-ttf/v1";
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
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-26.05";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nu_scripts = {
      url = "github:nushell/nu_scripts";
      flake = false;
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
      inputs.nix-darwin.follows = "nix-darwin";
    };
    vesktop = {
      url = "github:emonadeo/vesktop";
      flake = false;
    };
    yazi-flavors = {
      url = "github:yazi-rs/flavors";
      flake = false;
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
          wrapperModules = lib.mkOption { };
        };

        config = {
          systems = [
            "x86_64-linux"
            "aarch64-linux"
            "aarch64-darwin"
          ];
        };
      }
    );
}
