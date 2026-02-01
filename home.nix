# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                         Home Manager Configuration                         ║
# ║                                                                             ║
# ║  This file contains ALL user-level settings (dotfiles, user programs).    ║
# ║  Everything is controlled by variables.nix.                                ║
# ║                                                                             ║
# ║  Rebuild with: nh os switch (rebuilds both system and home)               ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  config,
  pkgs,
  variables,
  ...
}:

{
  # ═══════════════════════════════════════════════════════════════════════════
  # HOME MANAGER SETTINGS
  # ═══════════════════════════════════════════════════════════════════════════

  home.username = variables.username;
  home.homeDirectory = "/home/${variables.username}";
  home.stateVersion = variables.stateVersion;

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # USER PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════

  home.packages = with pkgs; [
    # Browsers
    (if variables.browser == "chromium" then chromium 
     else if variables.browser == "firefox" then firefox
     else if variables.browser == "brave" then brave
     else chromium)
    
    # Development
    (if variables.editor == "vscodium" then vscodium
     else if variables.editor == "neovim" then neovim
     else if variables.editor == "vim" then vim
     else if variables.editor == "helix" then helix
     else vscodium)
    
    # Terminal
    (if variables.terminal == "kitty" then kitty
     else if variables.terminal == "alacritty" then alacritty
     else if variables.terminal == "wezterm" then wezterm
     else kitty)
    
    # Communication
    discord
    telegram-desktop
    
    # Media
    vlc
    spotify
    
    # Office
    libreoffice-qt6-fresh
    
    # Utilities
    gnome-calculator
    gnome-disk-utility
    
    # Gaming (if hardware.opengl is enabled)
  ] ++ pkgs.lib.optionals variables.hardware.opengl [
    steam
    lutris
    heroic
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # GIT CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════

  programs.git = {
    enable = true;
    userName = variables.fullName;
    userEmail = variables.email;
    
    extraConfig = {
      init.defaultBranch = variables.git.defaultBranch;
      commit.gpgsign = variables.git.gpgSign;
      user.signingkey = if variables.git.gpgSign then variables.git.gpgKey else "";
      core.editor = variables.editor;
    };

    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "log --graph --oneline --all";
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SHELL CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════

  programs.bash = {
    enable = (variables.defaultShell == "bash");
    enableCompletion = true;
    
    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -lah --icons --group-directories-first";
      tree = "eza --tree --icons";
      cat = "bat";
      grep = "rg";
      find = "fd";
      ".." = "cd ..";
      "..." = "cd ../..";
      rebuild = "nh os switch";
      update = "nh os switch --update";
    };
  };

  programs.fish = {
    enable = (variables.defaultShell == "fish");
    
    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -lah --icons --group-directories-first";
      tree = "eza --tree --icons";
      cat = "bat";
      grep = "rg";
      find = "fd";
      ".." = "cd ..";
      "..." = "cd ../..";
      rebuild = "nh os switch";
      update = "nh os switch --update";
    };
  };

  programs.zsh = {
    enable = (variables.defaultShell == "zsh");
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -lah --icons --group-directories-first";
      tree = "eza --tree --icons";
      cat = "bat";
      grep = "rg";
      find = "fd";
      ".." = "cd ..";
      "..." = "cd ../..";
      rebuild = "nh os switch";
      update = "nh os switch --update";
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "sudo" "z" ];
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # STARSHIP PROMPT
  # ═══════════════════════════════════════════════════════════════════════════

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # TERMINAL EMULATORS
  # ═══════════════════════════════════════════════════════════════════════════

  programs.kitty = pkgs.lib.mkIf (variables.terminal == "kitty") {
    enable = true;
    theme = if variables.theme.style == "dark" then "Tokyo Night" else "Catppuccin-Latte";
    
    settings = {
      font_family = variables.theme.font.mono;
      font_size = 11;
      cursor_blink_interval = 0;
      enable_audio_bell = false;
      window_padding_width = 8;
      background_opacity = "0.95";
    };
  };

  programs.alacritty = pkgs.lib.mkIf (variables.terminal == "alacritty") {
    enable = true;
    
    settings = {
      font = {
        normal.family = variables.theme.font.mono;
        size = 11;
      };
      
      window = {
        opacity = 0.95;
        padding = {
          x = 8;
          y = 8;
        };
      };
      
      colors = if variables.theme.style == "dark" then {
        primary = {
          background = "#1a1b26";
          foreground = "#c0caf5";
        };
      } else {
        primary = {
          background = "#eff1f5";
          foreground = "#4c4f69";
        };
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # VSCODIUM
  # ═══════════════════════════════════════════════════════════════════════════

  programs.vscode = pkgs.lib.mkIf (variables.editor == "vscodium") {
    enable = true;
    package = pkgs.vscodium;
    
    userSettings = {
      "workbench.colorTheme" = if variables.theme.style == "dark" then "Tokyo Night" else "GitHub Light";
      "editor.fontFamily" = variables.theme.font.mono;
      "editor.fontSize" = 13;
      "editor.formatOnSave" = true;
      "editor.minimap.enabled" = false;
      "files.autoSave" = "afterDelay";
      "telemetry.telemetryLevel" = "off";
    };
    
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      ms-python.python
      rust-lang.rust-analyzer
      github.copilot
    ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # FIREFOX
  # ═══════════════════════════════════════════════════════════════════════════

  programs.firefox = pkgs.lib.mkIf (variables.browser == "firefox") {
    enable = true;
    
    profiles.${variables.username} = {
      settings = {
        "browser.startup.homepage" = "about:home";
        "privacy.donottrackheader.enabled" = true;
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # XDG (File associations, default apps)
  # ═══════════════════════════════════════════════════════════════════════════

  xdg = {
    enable = true;
    
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "${variables.browser}.desktop";
        "x-scheme-handler/http" = "${variables.browser}.desktop";
        "x-scheme-handler/https" = "${variables.browser}.desktop";
        "text/plain" = "${variables.editor}.desktop";
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # GTK THEMING
  # ═══════════════════════════════════════════════════════════════════════════

  gtk = {
    enable = true;
    
    theme = {
      name = if variables.theme.style == "dark" then "Adwaita-dark" else "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
    
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    
    font = {
      name = variables.theme.font.sans;
      size = 11;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # QT THEMING
  # ═══════════════════════════════════════════════════════════════════════════

  qt = {
    enable = true;
    platformTheme.name = "kde";
  };
}
