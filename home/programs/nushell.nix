{
  pkgs,
  inputs,
  ...
}:

{
  programs.nushell = {
    enable = true;
    environmentVariables = {
      TERMINAL = "ghostty";
      EDITOR = "nvim";
      GDK_SCALE = 1.667;
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$env.HOME | path join \".steam/root/compatibilitytools.d\"";
      HYPRCURSOR_THEME = "macos";
      HYPRCURSOR_SIZE = 24;
      QT_QPA_PLATFORM = "wayland";
      NIXOS_OZONE_WL = 1;
    };
    configFile = {
      text = ''
        $env.config.hooks.command_not_found = source ${
          pkgs.callPackage ../command_not_found.nix {
            nix-index = inputs.nix-index;
            nix-index-database = inputs.nix-index-database;
          }
        }
        if (tty) == "/dev/tty1" { exec hyprland }
      '';
    };
  };
}
