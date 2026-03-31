{ withSystem, ... }:
{
  flake.nixosModules.shell =
    { pkgs, ... }:
    (withSystem pkgs.stdenv.hostPlatform.system (
      { self', ... }:
      {
        # Bash/Zsh script that spawns Nushell if current shell has no other Nushell ancestors.
        #
        # See <https://wiki.nixos.org/wiki/Nushell#Installation>
        # and <https://wiki.nixos.org/wiki/Fish#Setting_fish_as_default_shell>
        programs.bash.interactiveShellInit = # sh
          ''
            if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != *"/bin/nu" && -z $BASH_EXECUTION_STRING ]] then
              if [[ -o login ]]; then
                  LOGIN_OPTION='--login'
              else
                  LOGIN_OPTION='''
              fi
              exec "${self'.packages.nushell}/bin/nu" "$LOGIN_OPTION"
            fi
          '';
      }
    ));
}
