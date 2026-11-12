{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.yazi = (
        inputs.wrappers.wrappers.yazi.wrap {
          inherit pkgs;
          plugins = {
            full-border = pkgs.yaziPlugins.full-border;
            git = pkgs.yaziPlugins.git;
            starship = pkgs.yaziPlugins.starship;
          };
          flavors = {
            catppuccin-latte = "${inputs.yazi-flavors}/catppuccin-latte.yazi";
            catppuccin-mocha = "${inputs.yazi-flavors}/catppuccin-mocha.yazi";
          };
          initLua =
            # lua
            ''
              require("full-border"):setup({ set = "rounded" })
              require("git"):setup()
              require("starship"):setup()
            '';
          settings = {
            theme = {
              flavor = {
                dark = "catppuccin-mocha";
                light = "catppuccin-latte";
              };
            };
          };
        }
      );
    };
}
