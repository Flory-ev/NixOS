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

  # Programs
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

  programs.plasma = {
    enable = true;

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
        location = "top";
        height = 25;
        alignment = "center";
        lengthMode = "fill";
        hiding = "none";
        floating = false;
        screen = "all";
        widgets = [
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
      {
        location = "bottom";
        height = 50;
        alignment = "center";
        lengthMode = "fit";
        hiding = "none";
        floating = true;
        screen = "all";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
        ];
      }
    ];
  };
}
