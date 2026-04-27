{ moduleWithSystem, ... }:
{
  flake.nixosModules.shell = moduleWithSystem (
    _perSystem@{ self', ... }:
    _nixos@{ pkgs, ... }:
    {
      # Bash/Zsh script that spawns Nushell if current shell has no other Nushell ancestors.
      #
      # See <https://wiki.nixos.org/wiki/Nushell#Installation>
      # and <https://wiki.nixos.org/wiki/Fish#Setting_fish_as_default_shell>
      # and <https://github.com/NixOS/nixpkgs/issues/193880#issuecomment-2639344679>
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

      # Start niri at login.
      # See <https://wiki.archlinux.org/title/Xinit#Autostart_X_at_login>
      # and <https://bbs.archlinux.org/viewtopic.php?id=295903>
      programs.bash.loginShellInit = # sh
        ''
          if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
            exec ${self'.packages.niri}/bin/niri-session -l
          fi
        '';
    }
  );
}
