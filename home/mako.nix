{ pkgs, ... }:

{
  services.mako = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    settings = {
      actions = true;
      anchor = "top-right";
      border-radius = 8;
      border-size = 1;
    };
  };
}
