{
  pkgs,
  inputs,
  config,
  ...
}:

{
  programs.nushell = {
    enable = true;
    # HACK: Make `config.home.sessionVariables` work with nushell
    # See <https://github.com/nix-community/home-manager/issues/4313>
    environmentVariables = config.home.sessionVariables;
    shellAliases = config.home.shellAliases;
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
        # See <https://github.com/ValveSoftware/gamescope/issues/1593>
        # and <https://github.com/ValveSoftware/gamescope/issues/1925>
        # if (tty) == "/dev/tty2" { exec steam-gamescope }
      '';
    };
  };
}
