# Adapted from <https://github.com/Lassulus/wrappers/blob/3cf1e8371129e8746d37c863c5d56a81fb16caa0/modules/ghostty/module.nix>

{ self, ... }:
{
  perSystem =
    {
      config,
      pkgs,
      self',
      ...
    }:
    {
      packages.rmpc = self.wrappers.rmpc.wrap {
        config = {
          inherit pkgs;
          config =
            # ron
            ''
              (
                cache_dir: Some("~/.cache/rmpc"),
                address: "/run/mpd/socket",
              )
            '';
        };
      };
    };
}
