{ pkgs, lib, inputs }:

{
  nix = {
    enable = true;
    package = pkgs.nix;
  };
}
