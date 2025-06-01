# Generates and returns `command-not-found.nu` script from
# `nix-index`, but uses `nix-locate` of `nix-index-database` instead of `nix-index`.
# This will probably be obsolete when v0.1.9 of `nix-index` is released and included in `nixpkgs`.

{
  nix-index,
  nix-index-database,
  pkgs,
}:

pkgs.runCommand "command-not-found-nix-index-database" { src = nix-index; } ''
  mkdir -p $out
  substitute $src/command-not-found.nu $out/command-not-found.nu \
    --replace-fail "@out@" "${nix-index-database.packages.${pkgs.system}.default}"
''
