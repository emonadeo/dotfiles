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
        $env.config.hooks.command_not_found = source ${pkgs.nix-index + /command-not-found.nu}
        if (tty) == "/dev/tty1" { exec ${config.programs.niri.package + /bin/niri-session} }
      '';
    };
  };
}
