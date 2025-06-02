{ inputs, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
    initLua = ''
      require("full-border"):setup({ type = ui.Border.ROUNDED })
      require("git"):setup()
      require("starship"):setup()
    '';
    plugins = {
      full-border = pkgs.yaziPlugins.full-border;
      git = pkgs.yaziPlugins.git;
      starship = pkgs.yaziPlugins.starship;
    };
    flavors = {
      catppuccin-latte = inputs.yazi-flavors + /catppuccin-latte.yazi;
      catppuccin-mocha = inputs.yazi-flavors + /catppuccin-mocha.yazi;
    };
    theme = {
      flavor = {
        dark = "catppuccin-mocha";
        light = "catppuccin-latte";
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "yazi.desktop";
  };
}
