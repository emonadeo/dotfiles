{ withSystem, ... }:
{
  flake.nixosModules.fonts =
    { pkgs, ... }:
    {
      fonts = withSystem pkgs.stdenv.hostPlatform.system (
        { config, ... }:
        {
          enableDefaultPackages = false;
          packages = builtins.concatLists [
            (map (font: font.package) config.fonts.emoji)
            (map (font: font.package) config.fonts.monospace)
            (map (font: font.package) config.fonts.sans)
            (map (font: font.package) config.fonts.serif)
          ];
          fontconfig = {
            localConf = # xml
              ''
                <?xml version="1.0"?>
                <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
                <fontconfig>
                  <match target="pattern">
                    <test qual="any" name="family"><string>Segoe UI</string></test>
                    <edit name="family" mode="assign" binding="same"><string>${builtins.elemAt config.fonts.sans 0}</string></edit>
                  </match>
                  ${map
                    (
                      font: # xml
                      ''
                        <match target="font">
                          <test name="family" compare="eq" ignore-blanks="true">
                            <string>${font.name}</string>
                          </test>
                          <edit name="fontfeatures" mode="append">
                            ${font.features.xml}
                          </edit>
                        </match>'')
                    (
                      builtins.filter (builtins.hasAttr "features") (
                        builtins.concatLists [
                          config.fonts.emoji
                          config.fonts.monospace
                          config.fonts.sans
                          config.fonts.serif
                        ]
                      )
                    )
                  }
                </fontconfig>
              '';
            defaultFonts = {
              emoji = map (font: font.name) config.fonts.emoji;
              monospace = map (font: font.name) config.fonts.monospace;
              sansSerif = map (font: font.name) config.fonts.sans;
              serif = map (font: font.name) config.fonts.serif;
            };
            hinting.enable = true;
            subpixel = {
              rgba = "rgb";
            };
          };
        }
      );
    };
}
