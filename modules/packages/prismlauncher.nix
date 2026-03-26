{
  perSystem =
    { pkgs, ... }:
    {
      packages.prismlauncher = (
        (pkgs.prismlauncher.override {
          jdks = [
            pkgs.graalvmPackages.graalvm-ce
            pkgs.jdk21
            pkgs.jdk25
          ];
        })
      );
    };
}
