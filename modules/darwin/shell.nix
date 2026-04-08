{ moduleWithSystem, ... }:
{
  flake.darwinModules.shell = moduleWithSystem (
    _perSystem@{ self', ... }:
    _darwin@{ pkgs, ... }:
    {
      # Bash/Zsh script that spawns Nushell if current shell has no other Nushell ancestors.
      #
      # See <https://github.com/nix-darwin/nix-darwin/issues/1028#issuecomment-2720875486>
      # and <https://wiki.nixos.org/wiki/Fish#Running_fish_interactively_with_zsh_as_system_shell_on_darwin>
      programs.zsh.interactiveShellInit = # sh
        ''
          if [[ $(ps -o command= -p "$PPID" | awk '{print $1}') != *"/bin/nu" && -z $ZSH_EXECUTION_STRING ]] then
            if [[ -o login ]]; then
                LOGIN_OPTION='--login'
            else
                LOGIN_OPTION='''
            fi
            exec "${self'.packages.nushell}/bin/nu" "$LOGIN_OPTION"
          fi
        '';
    }
  );
}
