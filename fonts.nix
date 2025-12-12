{ pkgs }:

{
  maple-mono = {
    name = "Maple Mono Normal NL";
    package = pkgs.maple-mono.NormalNL-TTF-AutoHint;
    features = rec {
      generic = {
        # Basic ligatures
        # calt = false;
        # Character variants
        # remove gaps
        # cv01 = true;
        # alternative a
        # cv02 = true;
        # alternative i
        # cv03 = false;
        # alternative l1
        # cv04 = false;
        # alternative g
        cv05 = true;
        # alternative i
        # cv06 = false;
        # alternative J
        # cv07 = false;
        # alternative r
        cv08 = true;
        # alternative a (italics)
        cv31 = true;
        # alternative f
        # cv32 = false;
        # alternative i and j
        # cv33 = true;
        # alternative k
        # cv34 = true;
        # alternative l
        # cv35 = true;
        # alternative x
        # cv36 = true;
        # alternative y
        # cv37 = false;
        # alternative g (italics)
        cv38 = true;
        # alternative i
        # cv39 = false;
        # alternative J
        # cv40 = false;
        # alternative r (italics)
        cv41 = true;
        # alternative ,;
        # cv61 = true;
        # alternative ?
        cv62 = false;
        # alternative left arrow (<=)
        # cv63 = false;
        # alternative left and right arrow (<= and >=)
        # cv64 = false;
        # alternative &
        # cv65 = false;
      };
      ghostty = builtins.attrValues (
        builtins.mapAttrs (name: value: "${if value then "+" else "-"}${name}") generic
      );
      xml = builtins.attrValues (
        builtins.mapAttrs (name: value: "<string>${name} ${if value then "on" else "off"}</string>") generic
      );
    };
  };
}
