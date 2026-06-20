# TODO: Configure
{
  perSystem =
    { pkgs, ... }:
    {
      packages.librewolf = pkgs.librewolf.override {
        extraPolicies = {
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
          ExtensionSettings = {
            # uBlock Origin
            "Block0@raymondhill.net" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            };
            # Unhook
            "myallychou@gmail.com" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/youtube-recommended-videos/latest.xpi";
            };
            # Clear URLs
            "{74145f27-f039-47ce-a470-a662b129930a}" = {
              installation_mode = "force_installed";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
            };
          };
        };
      };
    };
}
