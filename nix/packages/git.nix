{ inputs, self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.git = (
        inputs.wrappers-b.wrappers.git.wrap {
          inherit pkgs;
          settings = {
            user = self.lib.user;
          };
        }
      );
    };
}
