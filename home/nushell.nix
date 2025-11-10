{
  pkgs,
  ...
}:

{
  programs.zsh = {
    enable = true;
    # Run nushell (`.zshrc`)
    # Source: <https://github.com/nix-darwin/nix-darwin/issues/1028#issuecomment-2720875486>
    initContent = ''
      if [[ ! $(ps -T -o "comm" | tail -n +2 | grep "nu$") && -z $ZSH_EXECUTION_STRING ]]; then
        if [[ -o login ]]; then
            LOGIN_OPTION='--login'
        else
            LOGIN_OPTION='''
        fi
        exec nu "$LOGIN_OPTION"
      fi
    '';
  };

  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config.render_right_prompt_on_last_line = true
      $env.config.hooks.command_not_found = source ${pkgs.nix-index + /etc/profile.d/command-not-found.nu}
      $env.config.edit_mode = 'vi'
    '';
  };
}
