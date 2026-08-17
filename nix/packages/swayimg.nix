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
        package = pkgs.swayimg;
        flagSeparator = "=";
        flags = {
          "--config" = ../../swayimg/init.lua;
        };
      };
    };
}
