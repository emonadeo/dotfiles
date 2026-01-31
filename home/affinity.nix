{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  home.packages = lib.mkIf pkgs.stdenv.hostPlatform.isLinux [
    inputs.affinity.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
