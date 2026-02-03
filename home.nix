{
  config,
  pkgs,
  lib,
  ...
}:
{
  # ============================================================================
  # Home Manager Configuration
  # ============================================================================

  home = {
    username = "f";
    homeDirectory = "/home/f";
    stateVersion = "25.05";

    # ==========================================================================
    # User Packages
    # ==========================================================================

    packages = with pkgs; [
		  antigravity
		  bitwarden-desktop
		  chromium
		  discord
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

  # ============================================================================
  # Programs Configuration
  # ============================================================================

  programs = {
    home-manager.enable = true;

    # ==========================================================================
    # Shell & Terminal
    # ==========================================================================

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [ 
          "git"
          "sudo"
        ];
      };

      shellAliases = {
        boot = "nh os boot";
        clean = "nh os clean";
        switch = "nh os switch";
      };
    };

    # ==========================================================================
    # Shell Enhancements
    # ==========================================================================

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
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # ==========================================================================
    # Development Tools
    # ==========================================================================

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

    # ==========================================================================
    # Applications
    # ==========================================================================

    firefox.enable = true;
  };
}
