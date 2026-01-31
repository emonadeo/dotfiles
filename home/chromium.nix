{ pkgs, ... }:

{
  # TODO: Replace with Helium
  # FIXME: Chromium is not available on darwin
  programs.chromium = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    commandLineArgs = [ "--ozone-platform=wayland" ];
    extensions = [
      # BetterTTV
      { id = "ajopnjidmegmdimjlfnijceegpefgped"; }
      # Bitwarden
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
      # DeArrow
      { id = "enamippconapkdmgfgjchkhakpfinmaj"; }
      # Decentraleyes
      { id = "ldpochfccmkkmhdbclfhpagapcfdljkj"; }
      # GitHub file icons
      { id = "ficfmibkjjnpogdcfhfokmihanoldbfe"; }
      # Karakeep
      { id = "kgcjekpmcjjogibpjebkhaanilehneje"; }
      # Proton Pass
      { id = "ghmbeldphafepmbegfdlkpapadhbakde"; }
      # Refined GitHub
      { id = "hlepfoohegkhhmjieoechaddaejaokhf"; }
      # SponsorBlock
      { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; }
      # SteamDB
      { id = "kdbmhfkmnlmbkgbabkdealhhbfhlmmon"; }
      # uBlock Origin
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; }
    ];
  };
}
