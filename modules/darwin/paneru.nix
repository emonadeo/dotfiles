{ inputs, self, ... }:
{
  flake.darwinModules.paneru =
    { pkgs, ... }:
    {
      imports = [ inputs.paneru.darwinModules.paneru ];

      services.paneru = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.paneru;
      };
    };
}
