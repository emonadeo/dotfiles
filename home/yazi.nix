{
  inputs,
  lib,
  pkgs,
  ...
}:

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

  xdg = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    mimeApps.defaultApplications = {
      "inode/directory" = "yazi.desktop";
    };
    portal = {
      extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];
    };
    configFile = {
      "xdg-desktop-portal-termfilechooser/config" = {
        enable = true;
        # This is not TOML despite looking like it!
        # See <https://github.com/hunkyburrito/xdg-desktop-portal-termfilechooser#configuration>
        text = ''
          [filechooser]
          cmd = TERMCMD='${lib.getExe pkgs.ghostty} --title="terminal-filechooser" -e' ${
            pkgs.xdg-desktop-portal-termfilechooser + /share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
          }
          default_dir = $HOME
          open_mode = suggested
          save_mode = last
        '';
      };
    };
  };
}
