{ inputs, moduleWithSystem, ... }:
{
  flake.nixosModules.ai = moduleWithSystem (
    _perSystem@{ inputs', pkgs, ... }:
    _nixos@{ lib, ... }:
    let
      # PERF: These models take up a lot of disk space. Choose one in the future.
      models = [
        (pkgs.fetchFromHuggingFace {
          name = "gemma-4-12B-it-Q8_0";
          backend = "lfs";
          repoId = "ggml-org/gemma-4-12B-it-GGUF";
          rootDir = "gemma-4-12B-it-Q8_0.gguf";
          rev = "7e0fbb8205d1f4857f4606a38a65023aaeb5f544";
          hash = "sha256-RTBGQx5MxhiNe4L3JOrbAwkkgFW1OccTMwoXmkM0Hz0=";
        })
        (pkgs.fetchFromHuggingFace {
          name = "gemma-4-26B-A4B-it-Q8_0";
          backend = "lfs";
          repoId = "ggml-org/gemma-4-26B-A4B-it-GGUF";
          rootDir = "gemma-4-26B-A4B-it-Q8_0.gguf";
          rev = "bb4531cda34d1ea09d9814959ed4d5833cf2a4c8";
          hash = "sha256-gj0fOGjCI1D8Bc8I/QNBX7xSncppPDqhijumKWUFSSk=";
        })
      ];
    in
    {
      environment.systemPackages = [
        # Wrap `pi-coding-agent` to include `node` and `npm`.
        # This is needed for commands like `pi install npm:...`
        # NOTE: pi extensions can not be managed by nix without home-manager.
        # pi's config files live in $PI_CODING_AGENT_DIR together with other stateful
        # files that get modified at runtime. As such pointing $PI_CODING_AGENT_DIR
        # to /nix/store is not possible.
        (inputs.wrappers-b.lib.wrapPackage ({
          inherit pkgs;
          package = pkgs.pi-coding-agent;
          runtimePkgs = [ pkgs.nodejs ];
        }))
      ];

      services.llama-cpp = {
        enable = true;
        package = pkgs.llama-cpp-vulkan;
        settings = {
          ctx-size = 0;
          models-dir = pkgs.runCommand "llama-models" { } ''
            mkdir -p $out
            ${lib.join "\n" (map (model: "ln -s ${model} $out/${model.name}.gguf") models)}
          '';
        };
      };
    }
  );
}
