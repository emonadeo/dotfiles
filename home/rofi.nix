{
  config,
  pkgs,
  ...
}:

{
  programs.rofi = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    terminal = "${pkgs.ghostty}/bin/ghostty";
    location = "center";
    extraConfig = {
      show-icons = true;
      display-drun = "Applications";
      display-run = "Executables";
      display-window = "Windows";
      display-ssh = "SSH";
      # Default has `<span weight='light' size='small'><i>({generic})</i></span>`
      drun-display-format = "{name}";
    };
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          text-color = mkLiteral "#cdd6f4";
          background-color = mkLiteral "transparent";
        };
        scrollbar = {
          enabled = false;
        };
        window = {
          border = mkLiteral "3px solid";
          border-color = mkLiteral "#ffffff44";
          padding = mkLiteral "13px";
          width = mkLiteral "768px";
          background-color = mkLiteral "#1e1e2e";
          border-radius = mkLiteral "13px";
        };
        mainbox = {
          spacing = mkLiteral "13px";
          children = [
            "prompt"
            "inputbar"
            "message"
            "listview"
          ];
        };
        inputbar = {
          children = [
            "entry"
            "num-filtered-rows"
            "textbox-num-sep"
            "num-rows"
          ];
          padding = mkLiteral "13px";
          background-color = mkLiteral "#313244";
          border-radius = mkLiteral "8px";
        };
        textbox-num-sep = {
          expand = false;
          content = "/";
          text-color = mkLiteral "#6c7086";
        };
        message = { };
        listview = {
          scrollbar = false;
          spacing = mkLiteral "8px";
          lines = 8;
        };
        element = {
          orientation = mkLiteral "horizontal";
          children = [
            "element-icon"
            "element-text"
          ];
          spacing = mkLiteral "8px";
          background-color = mkLiteral "#313244";
          border-radius = mkLiteral "8px";
        };
        "element selected" = {
          background-color = mkLiteral "#cdd6f4";
        };
        element-text = {
          expand = true;
          vertical-align = mkLiteral "0.5";
        };
        "element-text selected" = {
          text-color = mkLiteral "#313244";
        };
        element-icon = {
          size = mkLiteral "34px";
          padding = mkLiteral "8px";
        };
      };
  };
}
