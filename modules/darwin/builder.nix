# NOTE: Temporary addition of a x86_64-linux builder to compile OOSTUBS.

{ inputs, ... }:
{
  flake.darwinModules.builder = {
    imports = [ inputs.nix-rosetta-builder.darwinModules.default ];

    # May need to enable this once to setup `nix-rosetta-builder`
    # Once `nix-rosetter-builder` is setup this can be disabled again.
    # nix.linux-builder.enable = true;
    nix-rosetta-builder.onDemand = true;
  };
}
