{
  getSystem,
  inputs,
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
      prefixVar = [
        [
          "XDG_CONFIG_DIRS"
          ":"
          (pkgs.symlinkJoin {
            name = "nvim-treesitter-parsers";
            postBuild = # sh
              ''
                mkdir -p $out/nvim
                mv $out/parser $out/nvim/parser
              '';
            paths = with pkgs.vimPlugins.nvim-treesitter-parsers; [
              asm
              astro
              bash
              c
              c3
              clojure
              cpp
              css
              csv
              cuda
              cue
              dart
              dockerfile
              editorconfig
              elixir
              erlang
              gitignore
              gleam
              glsl
              go
              graphql
              groovy
              hcl
              html
              ini
              java
              javascript
              jsdoc
              json
              json5
              just
              kdl
              kotlin
              latex
              lua
              luadoc
              markdown
              markdown_inline
              meson
              nginx
              nickel
              ninja
              nix
              nu
              ocaml
              odin
              php
              python
              query
              regex
              rust
              scss
              svelte
              swift
              toml
              tsx
              typescript
              typespec
              typst
              vala
              vim
              vimdoc
              vue
              wgsl
              xml
              yaml
              zig
            ];
          })
        ]
      ];
      extraPackages = [
        pkgs.astro-language-server
        pkgs.astro-language-server
        pkgs.ccls # C/C++
        pkgs.dprint # Universal formatter
        pkgs.emmet-language-server
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
        pkgs.typescript-go
        pkgs.vscode-langservers-extracted
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
