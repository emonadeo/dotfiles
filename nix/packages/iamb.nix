{ inputs, ... }:
{
  perSystem =
    { self', pkgs, ... }:
    {
      packages.iamb = inputs.wrappers-b.lib.wrapPackage {
        inherit pkgs;
        # BUG: Build failure
        # See <https://github.com/NixOS/nixpkgs/pull/501997>
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
