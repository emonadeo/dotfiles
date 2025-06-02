{
  config,
  inputs,
  pkgs,
  ...
}:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [ "${../wallpapers/camille-unknown_the-cave_2x.png}" ];
      wallpaper = [ ", ${../wallpapers/camille-unknown_the-cave_2x.png}" ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "ghostty";
      bind = [
        "$mod, Q, killactive"
        "$mod SHIFT, Q, exit"
        "$mod, T, exec, $terminal"
        "$mod, P, exec, nu -c \"slurp | grim -g \\$in - | wl-copy\""
        "$mod SHIFT, P, exec, nu -c \"grim -o (hyprctl -j activeworkspace | from json | get monitor) - | wl-copy\""
        "$mod, F, fullscreen"
        "$mod SHIFT, F, togglefloating"
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        "$mod, NEXT, focusmonitor, +1"
        "$mod, PRIOR, focusmonitor, -1"
        "$mod SHIFT, NEXT, movecurrentworkspacetomonitor, +1"
        "$mod SHIFT, PRIOR, movecurrentworkspacetomonitor, -1"
        "$mod SHIFT, HOME, movecurrentworkspacetomonitor, +1"
        "$mod SHIFT, END, movecurrentworkspacetomonitor, -1"
        "$mod, SPACE, exec, nu -c \"tofi-drun | hyprctl dispatch exec -- \\$in\""
        "$mod SHIFT, SPACE, exec, rofi -show drun"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
      ];
      decoration = {
        shadow.enabled = false;
        rounding = 6;
        blur = {
          enabled = true;
          # single pass looks poop
          # total size = passes * size
          # 8 = 1 * 8 = 2 * 4
          passes = 2;
          size = 4;
        };
      };
      general = {
        "col.inactive_border" = "0xff313244";
        "col.active_border" = "0xffcdd6f4";
        border_size = 2;
        gaps_in = 8;
        gaps_out = 16;
      };
      input = {
        kb_layout = "eu";
        accel_profile = "flat";
        force_no_accel = true;
      };
      # Prevent color picker and screenshot tools to capture selection borders
      layerrule = [
        "noanim, hyprpicker"
        "noanim, selection"
      ];
      monitor = [
        "HDMI-A-1, preferred, 0x0, 1.667"
        "DP-2, preferred, auto-right, 1.667"
      ];
      xwayland = {
        force_zero_scaling = true;
      };
      misc = {
        background_color = "0x000000";
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
      };
      debug = {
        full_cm_proto = true;
      };
    };
  };

  xresources = {
    path = "${config.home.homeDirectory}/.Xdefaults";
    properties = {
      "Xft.dpi" = 168;
      "Xft.autohint" = 0;
      "Xft.lcdfilter" = "lcddefault";
      "Xft.hintstyle" = "hintfull";
      "Xft.hinting" = 1;
      "Xft.antialias" = 1;
      "Xft.rgba" = "rgb";
    };
  };
}
