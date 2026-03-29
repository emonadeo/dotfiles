{ self, ... }:
{
  # Sh/Bash/Zsh script that spawns Nushell if current shell has no other Nushell ancestors.
  #
  # Source: <https://github.com/nix-darwin/nix-darwin/issues/1028#issuecomment-2720875486>
  flake.lib.shellInitNu =
    { pkgs }: # sh
    ''
      if [[ ! $(ps -T -o "comm" | tail -n +2 | grep "nu$") && -z $ZSH_EXECUTION_STRING ]]; then
        if [[ -o login ]]; then
            LOGIN_OPTION='--login'
        else
            LOGIN_OPTION='''
        fi
        exec "${self.packages.${pkgs.stdenv.hostPlatform.system}.nushell}/bin/nu" "$LOGIN_OPTION"
      fi
    '';

}
