{ inputs, pkgs, ... }:

{
  home = {
    file = {
      ".tgt/config/app.toml".source = ./tgt_app.toml;
      ".tgt/config/keymap.toml".source = ./tgt_keymap.toml;
      ".tgt/config/logger.toml".source = inputs.tgt + /config/logger.toml;
      ".tgt/config/telegram.toml".source = inputs.tgt + /config/telegram.toml;
      ".tgt/config/theme.toml".source = ./tgt_theme.toml;
    };
    packages = [
      (inputs.tgt.packages.${pkgs.system}.default.overrideAttrs (prev: rec {
        src = pkgs.fetchFromGitHub {
          owner = prev.src.owner;
          repo = prev.src.repo;
          rev = "140ccb3e0214b6966affa05eb90d300ad04e4d9a";
          sha256 = "sha256-IlmrOIBaqrduvyeEzFFjwXzILyIdlwAOV7aAwzLLC4I=";
        };
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-W60Kk6B+HhbJE65u/CVnAmRzZPVnkcoop+1uR+w9UBE=";
        };
      }))
    ];
  };
}
