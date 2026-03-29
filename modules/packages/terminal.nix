{ inputs, self, ... }:
{
  perSystem =
    {
      config,
      pkgs,
      self',
      ...
    }:
    let
      # Use the first monospace font for Ghostty
      # TODO: Include fallbacks once supported
      font = (builtins.elemAt config.fonts.monospace 0);
    in
    {
      # TODO: Do I really want to have `terminal` (nushell with full toolchain environment) and `ghostty` (no environment)?
      # Then what about `nushell` (no environment) and `?` (with full toolchain environment)
      packages.terminal = inputs.wrappers-b.lib.wrapPackage ({
        inherit pkgs;
        imports = [ self.wrapperModules.ghostty ];
        flags = {
          "--command" = "${self'.packages.nushell}/bin/nu";
        };
        font = {
          inherit (font) name package;
          features = font.features.ghostty;
        };
      });
    };
}
