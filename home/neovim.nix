{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
  };

  home = {
    file = {
      ".config/nvim" = {
        recursive = true;
        source = inputs.nvim;
      };
    };
  };

  # Remove Neovim from desktop entries
  xdg.desktopEntries.nvim = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    name = "Neovim";
    exec = "";
    noDisplay = true;
  };
}
