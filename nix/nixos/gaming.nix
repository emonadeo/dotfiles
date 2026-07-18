{ moduleWithSystem, ... }:
{
  flake.nixosModules.gaming = moduleWithSystem (
    _perSystem@{ self', ... }:
    _nixos@{ pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.balatro-mod-manager
        pkgs.dolphin-emu # Gamecube/Wii Emulator
        pkgs.heroic # Epic Games
        (pkgs.lutris.override {
          extraPkgs = pkgs: [
            pkgs.wineWow64Packages.waylandFull
          ];
          extraLibraries =
            pkgs: with pkgs; [
              libadwaita
              gtk4
            ];
        })
        pkgs.ryubing # Switch Emulator
        pkgs.shipwright # The Legend of Zelda: Ocarina of Time
        self'.packages.prismlauncher # Minecraft
      ];

      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
        };
        steam-hardware.enable = true;
      };

      programs = {
        gamemode.enable = true;
        gamescope = {
          enable = true;
          # BUG:
          # <https://discourse.nixos.org/t/unable-to-activate-gamescope-capsysnice-option/37843/10>
          # <https://github.com/NixOS/nixpkgs/issues/351516>
          capSysNice = true;
        };
        steam = {
          enable = true;
          extraCompatPackages = [ pkgs.proton-ge-bin ];
          extraPackages = [ pkgs.SDL2 ];
        };
      };
    }
  );
}
