{ inputs, self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.git = (
        inputs.wrappers-b.git.wrap {
          inherit pkgs;
          settings = {
            user = self.lib.user;
          };
        }
      );
    };
}
