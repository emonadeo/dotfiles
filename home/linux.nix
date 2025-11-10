# TODO: Refactor
{ lib, pkgs, ... }:
{
  home.packages = lib.mkIf pkgs.stdenv.hostPlatform.isLinux [
    pkgs.wl-clipboard
    pkgs.xdg-utils
  ];
}
