{ flake-parts-lib, lib, ... }:
{
  options.perSystem =
    let
      font = lib.types.submodule {
        options = {
          name = lib.mkOption {
            description = "Name of the font";
            type = lib.types.str;
          };
          package = lib.mkOption {
            description = "Font package";
            type = lib.types.package;
          };
          features = lib.mkOption {
            description = "Font features";
            type = lib.types.nullOr (
              lib.types.submodule {
                options = {
                  generic = lib.mkOption {
                    type = lib.types.attrsOf lib.types.bool;
                    description = "Font features as attribute set";
                    example = {
                      cv05 = true;
                      cv08 = true;
                      cv62 = false;
                    };
                  };
                  ghostty = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    description = "Font features formatted for Ghostty";
                    example = [
                      "+cv05"
                      "+cv08"
                      "-cv62"
                    ];
                  };
                  fontconfig = lib.mkOption {
                    type = lib.types.str;
                    description = "Font features formatted for fontconfig";
                    example = # xml
                      ''
                        <string>cv05 on</string>
                        <string>cv08 on</string>
                        <string>cv62 off</string>
                      '';
                  };
                };
              }
            );
          };
        };
      };
    in
    flake-parts-lib.mkPerSystemOption (
      { ... }:
      {
        options.fonts = lib.mkOption {
          description = "Font configuration to use across all packages and modules";
          type = lib.types.submodule {
            options = {
              monospace = lib.mkOption {
                type = font;
                description = "Monospace font";
              };
            };
          };
        };
      }
    );

  config.perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      # Turn a attribute set of font features into domain-specific configuration formats (ghostty, xml)
      mkFontFeatures = features: {
        generic = features;
        ghostty = builtins.attrValues (
          builtins.mapAttrs (name: value: "${if value then "+" else "-"}${name}") features
        );
        fontconfig = lib.strings.join "\n" (
          builtins.attrValues (
            builtins.mapAttrs (
              name: value: "<string>${name} ${if value then "on" else "off"}</string>"
            ) features
          )
        );
      };
      maple-mono = {
        name = "Maple Mono Normal NL";
        package = pkgs.maple-mono.NormalNL-TTF-AutoHint;
        features = mkFontFeatures {
          # alternative g
          cv05 = true;
          # alternative r
          cv08 = true;
          # alternative a (italics)
          cv31 = true;
          # alternative g (italics)
          cv38 = true;
          # alternative r (italics)
          cv41 = true;
          # alternative ?
          cv62 = false;
        };
      };
      departure-mono = {
        name = "Departure Mono";
        package = pkgs.departure-mono;
      };
    in
    {
      fonts = {
        monospace = departure-mono;
      };
    };
}
