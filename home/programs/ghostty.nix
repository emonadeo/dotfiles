{ ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      adjust-underline-thickness = 1;
      adjust-overline-thickness = 1;
      adjust-strikethrough-thickness = 1;
      background-opacity = 0.875;
      font-family = "Maple Mono";
      font-feature = [
        # basic ligatures
        "-calt"
        # character variants
        "+cv01" # remove gaps
        "+cv02" # alternative a
        "-cv03" # alternative i
        "-cv04" # alternative l1
        "+cv05" # alternative g
        "-cv06" # alternative i
        "-cv07" # alternative J
        "+cv08" # alternative r
        "+cv61" # alternative ,;
        "-cv62" # alternative ?
        "-cv63" # alternative left arrow (<=)
        "-cv64" # alternative left and right arrow (<= and >=)
        "-cv65" # alternative &
        # italic only
        "+cv31" # alternative a
        "-cv32" # alternative f
        "+cv33" # alternative i and j
        "+cv34" # alternative k
        "+cv35" # alternative l
        "+cv36" # alternative x
        "-cv37" # alternative y
        "+cv38" # alternative g
        "-cv39" # alternative i
        "-cv40" # alternative J
        "+cv41" # alternative r
      ];
      font-size = 13.5;
      # Use official `catppuccin-mocha.conf` instead of ported textmate theme
      theme = "catppuccin-mocha";
      window-padding-balance = true;
      window-padding-x = 16;
      window-padding-y = 16;
      window-inherit-working-directory = true;
    };
  };
}
