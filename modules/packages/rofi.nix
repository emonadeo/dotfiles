{ inputs, withSystem, ... }:
{
  flake.packages."x86_64-linux".rofi = withSystem "x86_64-linux" (
    {
      config,
      pkgs,
      self',
      ...
    }:
    {
      packages.rofi = (
        inputs.wrappers-b.wrappers.rofi.wrap {
          inherit pkgs;
          settings = {
            terminal = "${self'.packages.ghostty}/bin/ghostty";
            location = 0; # center
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
              # TODO: What lib provides this function?
              # Reverse engineered from <https://github.com/BirdeeHub/nix-wrapper-modules/blob/main/wrapperModules/r/rofi/module.nix>
              mkLiteral = value: {
                inherit value;
                _type = "literal";
              };
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
        }
      );
    }
  );
}
