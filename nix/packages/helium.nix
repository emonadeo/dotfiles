# TODO: Migrate to nixpkgs once available
# See <https://github.com/imputnet/helium/issues/320>
# and <https://github.com/NixOS/nixpkgs/pull/498572>
{
  perSystem = { pkgs, ... }: {
    packages.helium = pkgs.nur.repos.forkprince.helium-nightly.override {
      enableWideVine = true;
    };
  };
}
