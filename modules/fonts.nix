{
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      maple-mono = {
        name = "Maple Mono Normal NL";
        package = pkgs.maple-mono.NormalNL-TTF-AutoHint;
        features = rec {
          generic = {
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
          ghostty = builtins.attrValues (
            builtins.mapAttrs (name: value: "${if value then "+" else "-"}${name}") generic
          );
          xml = lib.strings.join "\n" (
            builtins.attrValues (
              builtins.mapAttrs (name: value: "<string>${name} ${if value then "on" else "off"}</string>") generic
            )
          );
        };
      };
    in
    {
      fonts = {
        monospace = maple-mono;
      };
    };
}
