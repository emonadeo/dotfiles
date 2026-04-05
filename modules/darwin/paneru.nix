{ lib, self, ... }:
{
  flake.darwinModules.paneru =
    { pkgs, ... }:
    {
      launchd.agents.paneru = {
        command = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.paneru;
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
        };
      };
    };
}
