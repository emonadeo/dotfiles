{ lib, withSystem, ... }:
{
  flake.darwinModules.paneru =
    { pkgs, ... }:
    (withSystem pkgs.stdenv.hostPlatform.system (
      { self', ... }:
      {
        launchd.user.agents.paneru = {
          command = lib.getExe self'.packages.paneru;
          serviceConfig = {
            KeepAlive = {
              Crashed = true;
              SuccessfulExit = false;
            };
            RunAtLoad = true;
          };
        };
      }
    ));
}
