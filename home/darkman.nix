{
  services.darkman = {
    enable = true;
    settings = {
      lat = 51.0;
      lng = 13.7;
    };
  };
  xdg.portal.config.common = {
    "org.freedesktop.impl.portal.Settings" = "darkman";
  };
}
