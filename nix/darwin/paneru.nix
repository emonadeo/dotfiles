{
  inputs,
  moduleWithSystem,
  ...
}:
{
  flake.darwinModules.paneru = moduleWithSystem (
    _perSystem@{ self', ... }:
    _darwin@{ pkgs, ... }:
    {
      imports = [ inputs.paneru.darwinModules.paneru ];

      services.paneru = {
        enable = true;
        settings = {
          options = {
            animation_speed = 32.0;
            preset_column_widths = [
              0.375
              0.5
              0.625
              0.75
            ];
          };
          bindings = {
            # Moves the focus between windows.
            window_focus_west = "ctrl + alt - h";
            window_focus_east = "ctrl + alt - l";
            window_focus_north = "ctrl + alt - k";
            window_focus_south = "ctrl + alt - j";
            # Swaps windows in chosen direction.
            window_swap_west = "ctrl + alt + shift - h";
            window_swap_east = "ctrl + alt + shift - l";
            # Centers the current window on screen.
            window_center = "ctrl + alt - c";
            # Cycles between the window sizes defined in the `preset_column_widths` option.
            window_resize = "ctrl + alt - r";
            window_fullwidth = "ctrl + alt - f";
            # Toggles the window for management. If unmanaged, the window will be "floating".
            window_manage = "ctrl + alt - t";
            # Stacks and unstacks a window into the left column. Each window gets a 1/N of the height.
            window_stack = "ctrl + alt - [";
            window_unstack = "ctrl + alt - ]";
            # Quits the window manager.
            quit = "ctrl + alt - q";
          };
          padding = {
            left = 16;
            right = 16;
            bottom = 16;
          };
          decorations = {
            workspace_menu_status = false;
            workspace_popup_status = false;
            inactive.dim.opacity = -0.1;
          };
          # Disable swipe gestures
          swipe.gesture = {
            fingers_count = 0;
            vertical = false;
          };
        };
      };
    }
  );
}
