{ pkgs, ... }:

{
  # BUG: Build failure on darwin
  # See <https://github.com/NixOS/nixpkgs/issues/485589>
  programs.element-desktop = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
  };

  programs.iamb = {
    enable = true;
  };
}
