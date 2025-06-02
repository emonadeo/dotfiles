{ config, ... }:

{
  programs.tofi = {
    enable = true;
    settings = {
      terminal = "ghostty -e";

      # Fonts
      font = "monospace";
      font-size = 16;

      # Text theming
      text-color = "#cdd6f4";
      prompt-color = "#f38ba8";
      selection-color = "#f9e2af";

      # Text cursor theme
      text-cursor-style = "block";

      # Text layout
      prompt-text = "> ";
      prompt-padding = 0;
      horizontal = false;

      # Window theming
      width = 1280;
      height = 720;
      background-color = "#1e1e2e";
      outline-width = 1;
      outline-color = "#ffffff";
      border-width = 1;
      border-color = "#ff00ff";
      corner-radius = 8;
      padding-top = 16;
      padding-right = 16;
      padding-bottom = 16;
      padding-left = 16;
      clip-to-padding = true;
      scale = true;

      # Window positioning
      anchor = "center";
      margin-top = 8;
      margin-right = 8;
      margin-bottom = 8;
      margin-left = 8;
    };
  };
}
