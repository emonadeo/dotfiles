{ lib, pkgs, ... }:
{
  home.packages = lib.mkIf pkgs.stdenv.hostPlatform.isLinux [ pkgs.teamspeak6-client ];
}
