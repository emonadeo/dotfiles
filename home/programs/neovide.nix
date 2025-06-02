{ pkgs, ... }:

{
  home = {
    packages = [
      pkgs.neovide
    ];
    file = {
      ".config/neovide/config.toml" = {
        source = ./neovide.toml;
      };
    };
  };
}
