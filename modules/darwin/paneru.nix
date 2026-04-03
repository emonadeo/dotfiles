{ lib, self, ... }:
{
  flake.darwinModules.paneru =
    { pkgs, ... }:
    {
      environment.launchAgents.paneru = {
        text = lib.generators.toPlist { escape = true; } {
          ProgramArguments = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.paneru;
          KeepAlive = {
            Crashed = true;
            SuccessfulExit = false;
          };
          RunAtLoad = true;
        };
      };
    };
}
