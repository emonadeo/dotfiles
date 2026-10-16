{ inputs, ... }:
{
  perSystem =
    { self', pkgs, ... }:
    {
      packages.iamb = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.iamb;
        flags = {
          "-c" = (pkgs.formats.toml { }).generate "iamb-config" {
            profiles.user = {
              user_id = "@emonadeo:matrix.org";
              settings = {
                notifications.enabled = true;
              };
            };
          };
        };
      };
    };
}
