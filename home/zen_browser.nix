{
  inputs,
  pkgs,
  ...
}:

{
  home.packages = [
    inputs.zen-browser.packages.${pkgs.system}.default
  ];

  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "zen-beta.desktop";
    "application/xhtml+xml" = "zen-beta.desktop";
    "text/html" = "zen-beta.desktop";
    "text/xml" = "zen-beta.desktop";
    "x-scheme-handler/http" = "zen-beta.desktop";
    "x-scheme-handler/https" = "zen-beta.desktop";
  };
}
