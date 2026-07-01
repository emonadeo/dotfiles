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
      # BUG: Patched vesktop fork to split settings from state not working properly
      # Quick solution: Go back to upstream vesktop and symlink settings into e.g. `/etc/vesktop`
      # Pretty solution: Contribute to vesktop to make readonly settings pointing to `/nix/store` possible.
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
