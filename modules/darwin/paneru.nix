{
  inputs,
  moduleWithSystem,
  ...
}:
{
  flake.darwinModules.paneru = moduleWithSystem (
    _perSystem@{ self', ... }:
    _darwin@{ pkgs, ... }:
    {
      imports = [ inputs.paneru.darwinModules.paneru ];

      services.paneru = {
        enable = true;
        package = self'.packages.paneru;
      };
    }
  );
}
