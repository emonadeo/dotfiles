{
  pkgs,
  ...
}:

{
  programs.zsh = {
    enable = true;
  };

  # Replace Bash with Zsh for the following reasons:
  # 1. Zsh provides more features than Bash
  # 2. Consistency with nix-darwin configurations, since macOS uses Zsh
  #
  # Ideally I would use nushell as my login shell, however this may cause
  # problems because nushell is not POSIX-compliant. Instead use Zsh as the
  # login shell which then spawns nushell. We configure this with home-manager
  # due to limitations with nushell.
  #
  # See <https://github.com/NixOS/nixpkgs/issues/193880#issuecomment-2639344679>.
  # and <https://wiki.nixos.org/wiki/Fish#Setting_fish_as_default_shell>.
  # This also works around <https://github.com/nix-community/home-manager/issues/4313>.
  users.defaultUserShell = pkgs.zsh;
}
