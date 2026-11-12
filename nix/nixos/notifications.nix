{ moduleWithSystem, ... }:
{
  flake.nixosModules.notifications = moduleWithSystem (
    _perSystem@{ self', ... }:
    _nixos@{ pkgs, ... }:
    let
      # TODO: Use a more customizable notification daemon (e.g. Quickshell, gotta coooonf)
      package = self'.packages.mako;
    in
    {
      services.dbus.packages = [ package ];
      systemd.packages = [ package ];
    }
  );
}
