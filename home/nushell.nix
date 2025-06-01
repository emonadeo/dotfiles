{
  pkgs,
  inputs,
  ...
}:

{
  programs.nushell = {
    enable = true;
    environmentVariables = {
      EDITOR = "nvim";
      GDK_SCALE = 1.667;
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$env.HOME | path join \".steam/root/compatibilitytools.d\"";
      HYPRCURSOR_THEME = "macos";
      HYPRCURSOR_SIZE = 24;
    };
    configFile = {
      text = ''
        $env.config.hooks.command_not_found = source ${
          pkgs.callPackage ./command-not-found.nix {
            nix-index = inputs.nix-index;
            nix-index-database = inputs.nix-index-database;
          }
        }
        if (tty) == "/dev/tty1" { exec hyprland }
      '';
    };
  };
}
