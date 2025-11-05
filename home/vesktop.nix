{ ... }:

{
  programs.vesktop = {
    enable = true;
    settings = {
      appBadge = false;
      arRPC = true;
      checkUpdates = false;
      customTitleBar = false;
      disableMinSize = true;
      minimizeToTray = false;
      tray = false;
      splashTheming = false;
      staticTitle = true;
      hardwareAcceleration = true;
      discordBranch = "stable";
    };
  };
}
