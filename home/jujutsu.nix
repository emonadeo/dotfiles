{ config, ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Emanuel Pilz";
        email = "emonadeo@gmail.com";
      };
      ui = {
        pager = "${config.programs.less.package + /bin/less} -FRX";
      };
    };
  };
}
