{
  inputs,
  pkgs,
  ...
}:

{
  imports = [ inputs.zen-browser.homeModules.beta ];
  programs.zen-browser = {
    enable = true;
    profiles."default" = {
      containersForce = true;
      containers = { };
      spacesForce = true;
      spaces = {
        "Browsing" = {
          id = "b6de089c-410d-4206-961d-ab11f988d40a";
          icon = "chrome://browser/skin/zen-icons/selectable/triangle.svg";
          position = 1000;
          theme = {
            opacity = 1.0;
            colors = [
              # `oklch(0.3 0.04 340)`
              {
                red = 59;
                green = 38;
                blue = 52;
              }
            ];
          };
        };
        "Development" = {
          id = "ddd10fab-4fc5-494b-9041-325e5759195b";
          icon = "chrome://browser/skin/zen-icons/selectable/code.svg";
          position = 2000;
          theme = {
            opacity = 1.0;
            colors = [
              # `oklch(0.3 0.04 270)`
              {
                red = 38;
                green = 45;
                blue = 66;
              }
            ];
          };
        };
        "Education" = {
          id = "e8aabdad-8aae-4fe0-8ff0-2a0c6c4ccc24";
          icon = "chrome://browser/skin/zen-icons/selectable/book.svg";
          position = 3000;
          theme = {
            opacity = 1.0;
            colors = [
              # `oklch(0.3 0.04 60)`
              {
                red = 61;
                green = 41;
                blue = 25;
              }
            ];
          };
        };
        "Profession" = {
          id = "ba1b2bc0-4c0a-4142-86ea-72bf598d14c9";
          icon = "chrome://browser/skin/zen-icons/selectable/circle.svg";
          position = 4000;
          theme = {
            opacity = 1.0;
            colors = [
              # `oklch(0.3, 0, 0)`
              {
                red = 46;
                green = 46;
                blue = 46;
              }
            ];
          };
        };
        "Design" = {
          id = "d393d70e-3947-437f-a104-a74aaa90d06c";
          icon = "chrome://browser/skin/zen-icons/selectable/palette.svg";
          position = 5000;
          theme = {
            opacity = 1.0;
            colors = [
              # `oklch(0.3 0.04 130)`
              {
                red = 39;
                green = 50;
                blue = 28;
              }
            ];
          };
        };
      };
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        betterttv
        bitwarden
        clearurls
        dearrow
        decentraleyes
        github-file-icons
        karakeep
        proton-pass
        refined-github
        sponsorblock
        steam-database
        ublock-origin
      ];
    };
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
    };
  };

  xdg.mimeApps =
    let
      # TODO: Move this function to a shared lib
      associations = builtins.listToAttrs (
        map
          (name: {
            inherit name;
            value = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta.meta.desktopFileName;
          })
          [
            "application/json"
            "application/pdf" # TODO: Get a proper PDF reader (like `Zathura`)
            "application/x-extension-htm"
            "application/x-extension-html"
            "application/x-extension-shtml"
            "application/x-extension-xht"
            "application/x-extension-xhtml"
            "application/xhtml+xml"
            "text/html"
            "text/xml"
            "text/plain"
            "x-scheme-handler/about"
            "x-scheme-handler/chrome"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
            "x-scheme-handler/mailto"
            "x-scheme-handler/unknown"
          ]
      );
    in
    {
      associations.added = associations;
      defaultApplications = associations;
    };
}
