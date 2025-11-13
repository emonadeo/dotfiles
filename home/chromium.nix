{ pkgs, ... }:

{
  # TODO: Replace with Helium
  # FIXME: Chromium is not available on darwin
  programs.chromium = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    commandLineArgs = [ "--ozone-platform=wayland" ];
    extensions = [
      # DeArrow
      { id = "enamippconapkdmgfgjchkhakpfinmaj"; }
      # Proton Pass
      { id = "ghmbeldphafepmbegfdlkpapadhbakde"; }
      # SponsorBlock
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
      # uBlock Origin
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; }
    ];
  };
}
