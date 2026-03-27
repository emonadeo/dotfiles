{ self, ... }:
{
  flake.nixosModules.gaming =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.dolphin-emu # Gamecube/Wii Emulator
        pkgs.heroic # Epic Games
        pkgs.lutris
        pkgs.ryubing # Switch Emulator
        pkgs.shipwright # The Legend of Zelda: Ocarina of Time
        self.packages.${pkgs.stdenv.hostPlatform.system}.prismlauncher # Minecraft
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
    };
}
