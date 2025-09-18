{
  inputs,
  pkgs,
  ...
}:

{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser.enable = true;

  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "zen-beta.desktop";
    "application/xhtml+xml" = "zen-beta.desktop";
    "text/html" = "zen-beta.desktop";
    "text/xml" = "zen-beta.desktop";
    "x-scheme-handler/http" = "zen-beta.desktop";
    "x-scheme-handler/https" = "zen-beta.desktop";
  };

  # stylix.targets.zen-browser = {
  #   enable = true;
  #   profileNames = [ "default" ];
  # };
}
