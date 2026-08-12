# TODO: Configure
{ inputs, ... }:
{
  perSystem =
    {
      inputs',
      self',
      pkgs,
      system,
      ...
    }:
    {
      packages.swayimg = inputs.wrappers-b.lib.wrapPackage {
        inherit pkgs;
        package = inputs'.nixpkgs-unstable.legacyPackages.swayimg;
        flagSeparator = "=";
        flags = {
          "--config" = ../../swayimg/init.lua;
        };
      };
    };
}
