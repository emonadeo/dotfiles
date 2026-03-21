{ lib, pkgs, ... }:

{
  programs.zathura = {
    enable = true;
  };

  xdg = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    mimeApps.defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
    };
  };
}
