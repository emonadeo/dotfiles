{ inputs, withSystem, ... }:
{
  flake.packages."aarch64-darwin".paneru = withSystem "aarch64-darwin" (
    { inputs', pkgs, ... }:
    inputs.wrappers-b.lib.wrapPackage {
      inherit pkgs;
      package = inputs'.paneru.packages.paneru;
      wrapperImplementation = "binary";
      env.PANERU_CONFIG = (pkgs.formats.toml { }).generate "paneru.toml" {
        options = {
          preset_column_widths = [
            0.33
            0.5
            0.66
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
        # NOTE: Experimental
        decorations.active.border = {
          enabled = true;
          width = 2.0;
        };
        # Prevent active border from being cut off
        padding = {
          left = 1;
          right = 1;
        };
      };
    }
  );
}
