{ inputs, lib, ... }:
let
  # Source: <https://github.com/nix-community/home-manager/blob/02371c05a04a2876cf92e2d67a259e8f87399068/modules/programs/mpv.nix#L27-L35>
  renderOption =
    option:
    rec {
      int = toString option;
      float = int;
      bool = lib.hm.booleans.yesNo option;
      string = option;
    }
    .${builtins.typeOf option};
  # Source: <https://github.com/nix-community/home-manager/blob/02371c05a04a2876cf92e2d67a259e8f87399068/modules/programs/mpv.nix#L37-L43>
  renderOptionValue =
    value:
    let
      rendered = renderOption value;
      length = toString (builtins.stringLength rendered);
    in
    "%${length}%${rendered}";
  # Source: <https://github.com/nix-community/home-manager/blob/02371c05a04a2876cf92e2d67a259e8f87399068/modules/programs/mpv.nix#L45-L48>
  renderOptions = lib.generators.toKeyValue {
    mkKeyValue = lib.generators.mkKeyValueDefault { mkValueString = renderOptionValue; } "=";
    listsAsDuplicateKeys = true;
  };
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.mpv = (
        inputs.wrappers-b.wrappers.mpv.wrap {
          inherit pkgs;
          "mpv.conf".content = renderOptions {
            # Builtin profiles:
            # - fast: can run on any hardware
            # - default: balanced profile between quality and performance
            # - high-quality: out of the box high quality experience. Intended mostly for dGPU.
            profile = "high-quality";
            ytdl-format = "bestvideo+bestaudio";
          };
          script = {
            uosc.path = pkgs.mpvScripts.uosc;
            mpris.path = (lib.mkIf pkgs.stdenv.hostPlatform.isLinux pkgs.mpvScripts.mpris);
          };
        }
      );
    };
}
