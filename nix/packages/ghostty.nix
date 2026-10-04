{ self, ... }:
{

  perSystem =
    {
      config,
      pkgs,
      self',
      ...
    }:
    {
      packages.ghostty = self.wrappers.ghostty.wrap ({
        inherit pkgs;
        meta.description = ''
          Preconfigured Ghostty
        '';
      });

      # BUG: On macOS the nix-darwin environment is not available because zsh invocation is skipped.
      # This includes most notably the `nix` command.
      # See <https://github.com/nix-darwin/nix-darwin/blob/06648f4902343228ce2de79f291dd5a58ee12146/modules/programs/zsh/default.nix#L150-L175>
      packages.ghostty-with-env = self.wrappers.ghostty.wrap ({
        inherit pkgs;
        flags = {
          "--command" = "${self'.packages.nushell}/bin/nu";
        };
        meta.description = ''
          Preconfigured Ghostty with Nushell environment
        '';
      });
    };
}
