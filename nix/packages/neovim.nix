{
  getSystem,
  lib,
  self,
  ...
}:
{
  flake.wrappers.neovim =
    { pkgs, wlib, ... }:
    let
      self' = (getSystem pkgs.stdenv.hostPlatform.system);
    in
    {
      imports = [ wlib.modules.default ];
      config = {
        package = pkgs.neovim-unwrapped;
        env.CC = lib.getExe pkgs.stdenv.cc; # Needed by `nvim-treesitter`
        runtimePkgs = [
          pkgs.astro-language-server
          pkgs.ccls # C/C++
          pkgs.dprint # Universal formatter
          pkgs.emmet-language-server
          pkgs.gdscript-formatter
          pkgs.jdt-language-server # Java
          pkgs.lua-language-server
          pkgs.nil # Nix
          pkgs.nixfmt
          pkgs.ripgrep # Needed by `snacks.picker`
          pkgs.rumdl # Markdown
          pkgs.rust-analyzer
          pkgs.rustfmt
          pkgs.stylua # Lua
          pkgs.svelte-language-server
          pkgs.tailwindcss-language-server
          pkgs.tombi # TOML
          pkgs.tree-sitter # Needed by `nvim-treesitter`
          pkgs.vscode-langservers-extracted
          # TODO: Migrate to TypeScript 7 which will include an LSP
          pkgs.vtsls # TypeScript
          pkgs.vue-language-server
          self'.packages.git
          self'.packages.jujutsu
        ];
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.neovim = self.wrappers.neovim.wrap ({
        inherit pkgs;
        # TODO: Wrap config
        meta.description = ''
          Neovim with bundled config and language servers
        '';
      });

      packages.neovim-test = self.wrappers.neovim.wrap ({
        inherit pkgs;
        meta.description = ''
          Neovim with bundled language servers
        '';
      });
    };
}
