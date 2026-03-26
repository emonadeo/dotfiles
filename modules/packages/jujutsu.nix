{ inputs, self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.jujutsu = (
        inputs.wrappers-b.wrappers.jujutsu.wrap {
          inherit pkgs;
          extraPackages = [ pkgs.less ];
          settings = {
            user = self.lib.user;
          };
        }
      );
    };
}
