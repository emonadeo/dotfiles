{ inputs, ... }:

{
  home = {
    file = {
      ".config/nvim" = {
        recursive = true;
        source = inputs.nvim;
      };
    };
  };

  # Remove Neovim from desktop entries
  xdg.desktopEntries.nvim = {
    name = "Neovim";
    exec = "";
    noDisplay = true;
  };
}
