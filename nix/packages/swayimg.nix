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
      packages.swayimg = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.swayimg;
        flagSeparator = "=";
        flags = {
          "--config" = ../../swayimg/init.lua;
        };
      };
    };
}
