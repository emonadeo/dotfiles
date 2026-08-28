{
  perSystem =
    { pkgs, ... }:
    {
      packages.vintagestory = pkgs.vintagestory.overrideAttrs (
        final: old: {
          version = "1.22.7";
          src = pkgs.fetchurl {
            url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${final.version}.tar.gz";
            hash = "sha256-SDzGgnpQwIxcQczQJixvEiPBBOVMpxNcRmBSeNifXeE=";
          };
        }
      );
    };
}
