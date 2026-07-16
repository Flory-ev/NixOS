{ pkgs, ... }:
{
  home = {
    username = "f";
    homeDirectory = "/home/f";
    stateVersion = "25.05";

    packages = with pkgs; [
      alacritty
      antigravity
      qbittorrent
      spotify
      sqlitebrowser
      termius
      telegram-desktop
      tor-browser
    ];
  };

  # ============================================================
  # Shell / git
  # ============================================================
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
      ];
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "F";
      user.email = "vladislavtkachuk@yahoo.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # ============================================================
  # Plasma (declarative KDE config via plasma-manager)
  # ============================================================
  programs.plasma = {
    enable = true;

    # Leave overrideConfig off for now: plasma-manager will only touch the
    # settings declared below and won't reset everything else to defaults
    # on login. Flip to `true` once the config below is "complete enough"
    # for a fully declarative desktop.
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
      options = [ "grp:win_space_toggle" ];
    };

    kwin = {
      # Minimalist single-desktop setup — no virtual-desktop switching.
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
