{ config, lib, pkgs, ... }:

{
  wayland.desktopManager.cosmic = {
    enable = true;

    /*
    # COSMIC configuration options provided by cosmic-manager:

    # Global Settings
    appearance = {
      theme = {
        mode = "Dark"; # "Light" | "Dark"
        /*
        colors = {
          accent = { r = 1.0; g = 1.0; b = 1.0; a = 1.0; };
          # See appearance.nix for more color options
        };
        */
      };
    };

    # Window Manager / Compositor
    compositor = {
      # acceleration = { profile = "Adaptive"; speed = 0.0; };
      # cursor_follows_focus = false;
      # focus_follows_cursor = false;
      # workspaces = { workspace_layout = "Vertical"; workspace_mode = "OutputBound"; };
      # xkb_config = { layout = "us"; model = ""; options = "terminate:ctrl_alt_bksp"; variant = ""; };
    };

    # Applets & UI Elements
    # applets = { ... };
    # panels = [ ... ];

    # Applications Settings
    # applications = {
    #   cosmic-term = { ... };
    #   cosmic-files = { ... };
    #   cosmic-edit = { ... };
    # };

    # Wallpaper
    # wallpapers = [ ... ];
    */
  };
}
