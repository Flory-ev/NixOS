{ pkgs, ... }:

{
  # --- Plasma (declarative KDE config via plasma-manager) ---
  programs.plasma = {
    enable = true;

    # Leave overrideConfig off for now: plasma-manager will only touch the
    # settings declared below and won't reset everything else to defaults
    # on login. Flip to `true` once the config below is "complete enough"
    # for a fully declarative desktop (mirrors the Niri philosophy).
    overrideConfig = false;

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      colorScheme = "BreezeDark";
      iconTheme = "breeze-dark";
      cursor.theme = "Breeze_Snow";
    };

    fonts.fixedWidth = {
      family = "JetBrains Mono";
      pointSize = 10;
    };

    input.keyboard = {
      numlockOnStartup = "on";
      layouts = [
        { layout = "us"; }
        { layout = "ru"; }
      ];
      # Same toggle used in the old Niri config.kdl
      options = [ "grp:win_space_toggle" ];
    };

    kwin = {
      # Minimalist single-desktop setup, similar in spirit to the
      # scrollable-column Niri layout — no virtual-desktop switching.
      virtualDesktops.number = 1;

      effects = {
        blur.enable = false;
        minimization.animation = "magiclamp";
      };

      titlebarButtons = {
        left = [ ];
        right = [
          "minimize"
          "maximize"
          "close"
        ];
      };
    };

    panels = [
      {
        location = "bottom";
        height = 44;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    hotkeys.commands = {
      launch-terminal = {
        name = "Launch Alacritty";
        key = "Meta+Return";
        command = "alacritty";
      };
    };
  };
}
