{ inputs, ... }:
{
  perSystem =
    { self', pkgs, ... }:
    let
      vesktopSettings = {
        appBadge = false;
        arRPC = true;
        checkUpdates = false;
        customTitleBar = false;
        disableMinSize = true;
        discordBranch = "stable";
        enableSplashScreen = false;
        hardwareAcceleration = true;
        hardwareVideoAcceleration = true;
        minimizeToTray = false;
        staticTitle = true;
        tray = false;
      };
      vencordSettings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        frameless = true;
        useQuickCss = false;
        winNativeTitleBar = true;
      };
    in
    {
      # TODO: Extract into wrapper module
      packages.vesktop = inputs.wrappers-b.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.vesktop.overrideAttrs (
          finalAttrs: old: {
            src = inputs.vesktop;
          }
        );
        env.VESKTOP_SETTINGS_DIR =
          pkgs.runCommand "vesktop-settings"
            {
              vesktopSettings = builtins.toJSON vesktopSettings;
              vencordSettings = builtins.toJSON vencordSettings;
              nativeBuildInputs = [ pkgs.jq ];
              passAsFile = [
                "vesktopSettings"
                "vencordSettings"
              ];
              preferLocalBuild = true;
            }
            # TODO: Support "$out/settings/quickCss.css" and "$out/settings/themes/quickCss.css"
            ''
              mkdir -p $out/settings
              jq . "$vesktopSettingsPath" > "$out/settings.json"
              jq . "$vencordSettingsPath" > "$out/settings/settings.json"
            '';
      };
    };
}
