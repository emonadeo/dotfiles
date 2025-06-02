{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = [
    # Patch Spotify with SpotX-Bash
    (import ../../overlays/spotify.nix { inherit inputs; })
  ];
  home.packages = [
    pkgs.spotify
  ];
}
