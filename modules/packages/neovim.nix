{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.neovim = (
        inputs.wrappers-b.neovim.wrap {
          inherit pkgs;
          extraPackages = [
            pkgs.nodejs # Needed by some plugins
            pkgs.astro-language-server
            pkgs.astro-language-server
            pkgs.ccls # C/C++
            pkgs.dprint # Universal formatter
            pkgs.emmet-language-server
            pkgs.jdt-language-server # Java
            pkgs.nil # Nix LSP
            pkgs.nixfmt
            pkgs.rust-analyzer
            pkgs.rustfmt
            pkgs.stylua # Lua
            pkgs.svelte-language-server
            pkgs.tombi # TOML
            pkgs.typescript-go
            pkgs.vscode-langservers-extracted
            pkgs.vue-language-server
          ];
        }
      );

      # TODO:
      packages.neovim-test = { };
    };
}
