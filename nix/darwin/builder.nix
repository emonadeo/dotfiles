# NOTE: Temporary addition of a x86_64-linux builder to compile OOSTUBS.

{ inputs, ... }:
{
  flake.darwinModules.builder = {
    # May need to enable this once to setup `nix-rosetta-builder`
    # Once `nix-rosetter-builder` is setup this can be disabled again.
    # nix.linux-builder.enable = true;

    imports = [ inputs.nix-rosetta-builder.darwinModules.default ];
    nix-rosetta-builder.onDemand = true;
  };
}
