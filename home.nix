{
  config,
  pkgs,
  lib,
  ...
}:
{
  home = {
    username = "f";
		homeDirectory = "/home/f";
    stateVersion = "25.05";

    packages = with pkgs; [
      antigravity
      bitwarden-desktop
      chromium
      discord
      firefox
      kitty
      lutris
      ncdu
      qbittorrent
      reaper
      spotify
      telegram-desktop
      thunderbird
      tor-browser
      tree
      vlc
      vscodium
    ];
  };

  programs = {
    bat = {
      enable = true;
      config.theme = "TwoDark";
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = true;
    };

    firefox.enable = true;

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      userName = "F";
      userEmail = "vladislavtkachuk@yahoo.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        };
    };

    home-manager.enable = true;

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      autosuggestion.enable = true;
      enable = true;
      enableCompletion = true;
			syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
      };
      shellAliases = {
        ".." = "cd ..";
        la = "ls -la";
        ll = "ls -l";
      };
    };
  };
}
