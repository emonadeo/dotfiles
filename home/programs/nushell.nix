{
  pkgs,
  inputs,
  config,
  ...
}:

{
  programs.nushell = {
    enable = true;
    environmentVariables = {
      TERMINAL = "ghostty";
      EDITOR = "nvim";
      GDK_SCALE = 1.667;
      HYPRCURSOR_THEME = "macos";
      HYPRCURSOR_SIZE = 24;
      QT_QPA_PLATFORM = "wayland";
      NIXOS_OZONE_WL = 1;
    };
    configFile = {
      text = ''
        $env.config.render_right_prompt_on_last_line = true
        $env.config.hooks.command_not_found = source ${
          pkgs.runCommand "command-not-found-nix-index-database" { src = inputs.nix-index; } ''
            mkdir -p $out
            substitute $src/command-not-found.nu $out/command-not-found.nu \
              --replace-fail "@out@" "${inputs.nix-index-database.packages.${pkgs.system}.default}"
          ''
          + /command-not-found.nu
        }
        if (tty) == "/dev/tty1" { exec ${config.programs.niri.package + /bin/niri-session} }
        # BUG: Black screen
        # https://github.com/ValveSoftware/gamescope/issues/1593
        # https://github.com/ValveSoftware/gamescope/issues/1925
        # if (tty) == "/dev/tty2" { exec steam-gamescope }
      '';
    };
  };
}
