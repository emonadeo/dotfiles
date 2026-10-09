{ inputs, self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.git = (
        inputs.wrappers.wrappers.git.wrap {
          inherit pkgs;
          settings = {
            user = self.lib.user;
          };
        }
      );
    };
}
