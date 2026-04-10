{
  getSystem,
  inputs,
  lib,
  self,
  ...
}:
{
  flake.wrapperModules.neovim =
    { pkgs, ... }:
    let
      self' = (getSystem pkgs.stdenv.hostPlatform.system);
    in
    {
      package = pkgs.neovim-unwrapped;
      # Needed by `nvim-treesitter`
      env.CC = lib.getExe pkgs.stdenv.cc;
      extraPackages = [
        pkgs.astro-language-server
        pkgs.ccls # C/C++
        pkgs.dprint # Universal formatter
        pkgs.emmet-language-server
        pkgs.lua-language-server
        pkgs.jdt-language-server # Java
        # TODO: Replace with self'.packages.jujutsu
        pkgs.jujutsu
        pkgs.nil # Nix LSP
        pkgs.nixfmt
        pkgs.ripgrep # Needed by `snacks.picker`
        pkgs.rust-analyzer
        pkgs.rustfmt
        pkgs.stylua # Lua
        pkgs.svelte-language-server
        pkgs.tombi # TOML
        pkgs.tree-sitter
        pkgs.vscode-langservers-extracted
        pkgs.vtsls # TypeScript
        pkgs.vue-language-server
        self'.packages.git
        self'.packages.jujutsu
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.neovim = inputs.wrappers-b.lib.wrapPackage ({
        inherit pkgs;
        imports = [ self.wrapperModules.neovim ];
        # TODO: Wrap config
        meta.description = ''
          Neovim with bundled config and language servers
        '';
      });

      packages.neovim-test = inputs.wrappers-b.lib.wrapPackage ({
        inherit pkgs;
        imports = [ self.wrapperModules.neovim ];
        meta.description = ''
          Neovim with bundled language servers
        '';
      });
    };
}
