{ inputs, ... }:
let
  wrapperModule =
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
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.neovim = inputs.wrappers-b.lib.wrapPackage ({
        inherit pkgs;
        imports = [ wrapperModule ];
        # TODO: Wrap config
        meta.description = ''
          Neovim with bundled config and language servers
        '';
      });

      packages.neovim-test = inputs.wrappers-b.lib.wrapPackage ({
        inherit pkgs;
        imports = [ wrapperModule ];
        meta.description = ''
          Neovim with bundled language servers
        '';
      });
    };
}
