{ pkgs, ... }:
{
  home = {
    username = "f";
    homeDirectory = "/home/f";
    stateVersion = "25.05";

    packages = with pkgs; [
      qbittorrent
      spotify
      termius
      telegram-desktop
    ];
  };

  # Programs
  programs = {
    gh = {
      enable = true;
    };
    git = {
      enable = true;
      settings = {
        user.name = "F";
        user.email = "vladislavtkachuk@yahoo.com";
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
    };
    zed-editor = {
      enable = true;
      extensions = [ "nix" ];
      userSettings = {
        theme = {
          mode = "system";
          dark = "One Dark";
          light = "One Light";
        };
      };
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };
    plasma = {
      enable = true;
      overrideConfig = true;

      workspace = {
        wallpaperPlainColor = "0,0,0";
        lookAndFeel = "org.kde.breezedark.desktop";
        colorScheme = "BreezeDark";
        iconTheme = "breeze-dark";
        cursor.theme = "Breeze_Snow";
      };

      fonts = let
        mono = { family = "JetBrains Mono"; pointSize = 10; };
      in {
        general = mono;
        fixedWidth = mono;
        toolbar = mono;
        menu = mono;
        windowTitle = mono;
        small = { family = "JetBrains Mono"; pointSize = 8; };
      };

      input.keyboard = {
        layouts = [
          { layout = "us"; }
          { layout = "ru"; }
        ];
        options = [ "grp:logo_space_toggle" ];
      };

      kwin = {
        virtualDesktops.number = 1;

        effects = {
          blur.enable = true;
          minimization.animation = "magiclamp";
        };

        titlebarButtons = {
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
          widgets = [
            "org.kde.plasma.panelspacer"
            "org.kde.plasma.systemtray"
            "org.kde.plasma.digitalclock"
          ];
        }
        {
          location = "bottom";
          height = 50;
          lengthMode = "fit";
          floating = true;
          widgets = [
            "org.kde.plasma.kickoff"
            "org.kde.plasma.icontasks"
          ];
        }
      ];
    };
  };
}
