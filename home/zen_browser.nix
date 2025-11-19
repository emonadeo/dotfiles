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
      ExtensionSettings =
        let
          mkExtensionSetting = (
            pluginId: {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
              installation_mode = "force_installed";
            }
          );
        in
        {
          "78272b6fa58f4a1abaac99321d503a20@proton.me" = mkExtensionSetting "proton-pass";
          "@searchengineadremover" = mkExtensionSetting "searchengineadremover";
          "deArrow@ajay.app" = mkExtensionSetting "dearrow";
          "firefox-extension@steamdb.info" = mkExtensionSetting "steam-database";
          "github-repository-size@pranavmangal" = mkExtensionSetting "gh-repo-size";
          "jid1-BoFifL9Vbdl2zQ@jetpack" = mkExtensionSetting "decentraleyes";
          "sponsorBlocker@ajay.app" = mkExtensionSetting "sponsorblock";
          "uBlock0@raymondhill.net" = mkExtensionSetting "ublock-origin";
          "{74145f27-f039-47ce-a470-a662b129930a}" = mkExtensionSetting "clearurls";
          "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = mkExtensionSetting "github-file-icons";
          "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = mkExtensionSetting "refined-github-";
        };
    };
  };

  xdg.mimeApps =
    let
      # Map array elements `e` into an attribute set `e = inputs.zen-browser.packages.${pkgs.system}.beta;`
      # TODO: Move this function to a shared lib
      associations = builtins.listToAttrs (
        map
          (name: {
            inherit name;
            value = inputs.zen-browser.packages.${pkgs.system}.beta.meta.desktopFileName;
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

  # stylix.targets.zen-browser = {
  #   enable = true;
  #   profileNames = [ "default" ];
  # };
}
