# TODO: Configure
{ inputs, ... }:
{
  perSystem =
    {
      self',
      pkgs,
      system,
      ...
    }:
    {
      packages.swayimg = inputs.wrappers-b.lib.wrapPackage {
        inherit pkgs;
        package = inputs.nixpkgs-unstable.legacyPackages.${system}.swayimg;
        flagSeparator = "=";
        flags = {
          "--config" = ../../swayimg/init.lua;
        };
      };
    };
}
