{
  flake.wrappers.rmpc =
    {
      config,
      lib,
      pkgs,
      wlib,
      ...
    }:
    {
      imports = [ wlib.modules.default ];
      options = {
        # TODO: Write a Nix to RON serializer (semi-large scope)
        config = lib.mkOption {
          type = lib.types.str;
          default = { };
          description = ''
            Configuration of rmpc in the Rusty Object Notation (RON) format.
            See <https://rmpc.mierak.dev/configuration/>
          '';
        };
        withYtDlp = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Include yt-dlp to enable youtube playback (`addyt`/`searchyt`).
            You still need to set `cache_dir` in `config` for these to work.
            See <https://rmpc.mierak.dev/guides/youtube/>
          '';
        };
      };
      config = {
        package = lib.mkDefault pkgs.rmpc;
        runtimePkgs = lib.optionals config.withYtDlp [ pkgs.yt-dlp ];
        flags."--config" = config.constructFiles.generatedConfig.path;
        constructFiles.generatedConfig = {
          content = config.config;
          relPath = "${config.binName}-config.ron";
        };
      };
    };
}
