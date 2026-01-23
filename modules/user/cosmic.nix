{
  config,
  lib,
  pkgs,
  ...
}:

{
  wayland.desktopManager.cosmic = {
    enable = true;

    panels = [
      {
        name = "Top Panel";
        anchor = {
          __type = "enum";
          variant = "Top";
        };
        anchor_gap = true;
        margin = 0;
        expand_to_edges = true;
        plugins_center = {
          __type = "optional";
          value = [ "com.system76.CosmicAppletTime" ];
        };
        plugins_wings = {
          __type = "optional";
          value = {
            __type = "tuple";
            value = [
              [
                "com.system76.CosmicPanelAppButton"
                "com.system76.CosmicPanelWorkspacesButton"
              ]
              [
                "com.system76.CosmicAppletStatusArea"
                "com.system76.CosmicAppletTiling"
                "com.system76.CosmicAppletAudio"
                "com.system76.CosmicAppletNetwork"
                "com.system76.CosmicAppletPower"
              ]
            ];
          };
        };
      }
      {
        name = "Dock";
        anchor = {
          __type = "enum";
          variant = "Bottom";
        };
        anchor_gap = true;
        margin = 12;
        expand_to_edges = false;
        opacity = 0.5;
        size = {
          __type = "enum";
          variant = "L";
        };
        background = {
          __type = "enum";
          variant = "Dark";
        };
        plugins_center = {
          __type = "optional";
          value = [ "com.system76.CosmicAppList" ];
        };
      }
    ];

    # --- COSMIC Configuration Options Reference ---

    /*
      # Appearance Settings
      appearance = {
        theme = {
          mode = "Dark"; # "Light" | "Dark"
          # colors = {
          #   accent = { r = 1.0; g = 1.0; b = 1.0; a = 1.0; };
          # };
        };
      };

      # Compositor (Window Manager) Settings
      compositor = {
        # acceleration = { profile = { __type = "enum"; variant = "Flat"; }; speed = 0.0; };
        cursor_follows_focus = false;
        focus_follows_cursor = false;
        workspaces = {
          workspace_layout = { __type = "enum"; variant = "Vertical"; };
          workspace_mode = { __type = "enum"; variant = "OutputBound"; };
        };
        # xkb_config = { layout = "us"; model = ""; options = "terminate:ctrl_alt_bksp"; variant = ""; };
      };

      # Idle / Power Management
      idle = {
        # Times in milliseconds
        screen_off_time = { __type = "optional"; value = 900000; }; # 15 mins
        suspend_on_ac_time = { __type = "optional"; value = 1800000; }; # 30 mins
        suspend_on_battery_time = { __type = "optional"; value = 900000; }; # 15 mins
      };

      # Custom Shortcuts
      shortcuts = [
        {
          key = "Super+T";
          action = { __type = "enum"; variant = "Terminal"; };
          description = "Open Terminal";
        }
      ];

      # System Action Overrides
      systemActions = {
        __type = "map";
        value = [
          # { key = { __type = "enum"; variant = "Terminal"; }; value = "ghostty"; }
        ];
      };

      # Wallpapers
      wallpapers = [
        {
          output = "all"; # or output name like "eDP-1"
          source = "/path/to/wallpaper.jpg";
          # filter = { __type = "enum"; variant = "Scale"; };
          # mode = { __type = "enum"; variant = "Zoom"; };
        }
      ];

      # Files Settings (cosmic-files)
      # applications.cosmic-files = {
      #   show_hidden = true;
      #   sort_column = "Name";
      #   sort_order = "Ascending";
      # };
    */
  };
}
