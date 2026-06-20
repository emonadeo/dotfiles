{
  flake.nixosModules.networking =
    { pkgs, ... }:
    {
      networking = {
        hostName = "ursa";
        networkmanager = {
          enable = true;
          plugins = [ pkgs.networkmanager-openvpn ];
        };
        interfaces = {
          enp11s0.useDHCP = true;
          wlp10s0.useDHCP = true;
        };
        firewall = {
          enable = true;
          checkReversePath = false;
          allowedTCPPorts = [ ];
          allowedUDPPorts = [ ];
        };
      };

      environment.systemPackages = [
        pkgs.eduvpn-client
      ];
    };
}
