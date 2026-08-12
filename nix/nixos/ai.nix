{ moduleWithSystem, ... }:
{
  flake.nixosModules.ai = moduleWithSystem (
    _perSystem@{ inputs', pkgs, ... }:
    _nixos@{ lib, ... }:
    let
      # TODO: Switch to stable channel once possible
      pkgs' = inputs'.nixpkgs-unstable.legacyPackages;
      models = [
        (pkgs'.fetchFromHuggingFace {
          name = "gemma-4-12B-it-Q8_0";
          backend = "lfs";
          repoId = "ggml-org/gemma-4-12B-it-GGUF";
          rootDir = "gemma-4-12B-it-Q8_0.gguf";
          rev = "7e0fbb8205d1f4857f4606a38a65023aaeb5f544";
          hash = "sha256-RTBGQx5MxhiNe4L3JOrbAwkkgFW1OccTMwoXmkM0Hz0=";
        })
      ];
    in
    {
      environment.systemPackages = [
        pkgs'.pi-coding-agent
      ];

      services.llama-cpp = {
        enable = true;
        package = pkgs'.llama-cpp-vulkan;
        # TODO: Try out Kimi-K3 once supported
        # See <https://github.com/ggml-org/llama.cpp/pull/26185>
        modelsDir = pkgs.runCommand "llama-models" { } ''
          mkdir -p $out
          ${lib.join "\n" (map (model: "ln -s ${model} $out/${model.name}.gguf") models)}
        '';
      };
    }
  );
}
