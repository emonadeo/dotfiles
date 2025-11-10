{ pkgs, ... }:
{
  programs.lutris = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
  };
}
