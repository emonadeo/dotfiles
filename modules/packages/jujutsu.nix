{ inputs, self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.jujutsu = (
        inputs.wrappers-b.wrappers.jujutsu.wrap {
          inherit pkgs;
          runtimePkgs = [ pkgs.less ];
          settings = {
            user = self.lib.user;
          };
        }
      );
    };
}
