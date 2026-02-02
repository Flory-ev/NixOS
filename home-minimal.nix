{
  config,
  pkgs,
  lib,
  variables,
  ...
}:

{
  home = {
    username = variables.username;
    homeDirectory = "/home/${variables.username}";
    stateVersion = variables.stateVersion;

    sessionVariables = {
      EDITOR = variables.editor;
      BROWSER = variables.browser;
      TERMINAL = variables.terminal;
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    };

    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
    ];
  };

  programs.home-manager.enable = true;

  # Packages
  home.packages = with pkgs; [
    # Browser
    (if variables.browser == "chromium" then chromium else firefox)

    # Editor
    (if variables.editor == "vscodium" then vscodium else neovim)

    # Terminal
    (if variables.terminal == "kitty" then kitty else alacritty)

    # Terminal multiplexer
    (if variables.terminalMultiplexer == "tmux" then tmux else null)

    # Languages
    nodejs_20
    python3
    rustc
    cargo
    go

    # Dev tools
    gh
    lazygit

    # Communication
    (lib.mkIf variables.apps.discord discord)
    (lib.mkIf variables.apps.telegram telegram-desktop)

    # Media
    (lib.mkIf variables.apps.vlc vlc)
    (lib.mkIf variables.apps.spotify spotify)

    # Office
    (lib.mkIf variables.apps.libreoffice libreoffice-qt6-fresh)
    obsidian

    # Utils
    pavucontrol
    gnome-calculator
  ];

  # Git
  programs.git = {
    enable = true;
    userName = variables.fullName;
    userEmail = variables.email;
    extraConfig = {
      init.defaultBranch = variables.git.defaultBranch;
      pull.rebase = variables.git.pullRebase;
      push.autoSetupRemote = true;
    };
  };

  # Zsh
  programs.zsh = lib.mkIf (variables.defaultShell == "zsh") {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
    };

    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
    };
  };

  # Kitty
  programs.kitty = lib.mkIf (variables.terminal == "kitty") {
    enable = true;
    theme = if variables.theme.style == "dark" then "Tokyo Night" else "GitHub Light";
    font = {
      name = variables.theme.font.mono;
      size = variables.theme.font.size;
    };
    settings = {
      background_opacity = "0.95";
      confirm_os_window_close = 0;
    };
  };

  # Tmux
  programs.tmux = lib.mkIf (variables.terminalMultiplexer == "tmux") {
    enable = true;
    terminal = "tmux-256color";
    mouse = true;
    keyMode = "vi";
    extraConfig = ''
      set -g status-style 'bg=#1e1e2e fg=#cdd6f4'
    '';
  };

  # Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Eza (ls replacement)
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = true;
  };

  # Bat (cat replacement)
  programs.bat = {
    enable = true;
    config.theme = if variables.theme.style == "dark" then "TwoDark" else "GitHub";
  };

  # Fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Zoxide
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
