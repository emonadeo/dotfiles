{ inputs, self, ... }:
{
  flake.wrapperModules.neovim =
    { pkgs, ... }:
    {
      imports = [ inputs.wrappers-b.lib.wrapperModules.neovim ];
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
    };

  perSystem =
    { pkgs, ... }:
    {
      # TODO: Neovim with wrapped config
      packages.neovim = inputs.wrappers-b.lib.wrapPackage ({
        inherit pkgs;
        imports = [ self.wrapperModules.neovim ];
      });

      # TODO: Neovim with dynamic config
      packages.neovim-test = inputs.wrappers-b.lib.wrapPackage ({
        inherit pkgs;
        imports = [ self.wrapperModules.neovim ];
      });
    };
}
