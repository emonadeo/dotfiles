{
  flake.nixosModules.nix = {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [ "https://cache.garnix.io" ];
        trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
      };
      gc.automatic = true;
      optimise.automatic = true;
    };

    nixpkgs = {
      config = {
        cudaSupport = false;
        rocmSupport = true;
        allowUnfree = true;
      };
    };
  };
}
