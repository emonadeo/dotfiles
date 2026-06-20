{
  flake.nixosModules.audio =
    { pkgs, ... }:
    {
      # Daemon for playerctld to track currently active media player
      services.playerctld.enable = true;

      # Audio server
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        jack.enable = true;
        # BUG: Breaks pipewire 1.6.3
        # See <https://gitlab.freedesktop.org/pipewire/pipewire/-/work_items/5222>
        # extraConfig = {
        #   pipewire."99-input-denoising" = {
        #     "context.modules" = [
        #       {
        #         "name" = "libpipewire-module-filter-chain";
        #         "args" = {
        #           "node.description" = "DeepFilter Noise Cancelling Source";
        #           "media.name" = "DeepFilter Noise Cancelling Source";
        #           "filter.graph" = {
        #             "nodes" = [
        #               {
        #                 "type" = "ladspa";
        #                 "name" = "DeepFilter Mono";
        #                 "plugin" = "${pkgs.deepfilternet}/lib/ladspa/libdeep_filter_ladspa.so";
        #                 "label" = "deep_filter_mono";
        #               }
        #             ];
        #           };
        #           "audio.rate" = 48000;
        #           "capture.props" = {
        #             "node.name" = "deep_filter_mono_input";
        #             "node.passive" = true;
        #           };
        #           "playback.props" = {
        #             "node.name" = "deep_filter_mono_output";
        #             "media.class" = "Audio/Source";
        #           };
        #         };
        #       }
        #     ];
        #   };
        # };
      };
    };
}
