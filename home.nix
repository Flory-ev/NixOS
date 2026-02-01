# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                         Home Manager Configuration                         ║
# ║                                                                             ║
# ║  This file contains ALL user-level settings (dotfiles, user programs).    ║
# ║  Everything is controlled by variables.nix.                                ║
# ║                                                                             ║
# ║  Rebuild with: nh os switch (rebuilds both system and home)               ║
# ║                or: home-manager switch                                     ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  config,
  pkgs,
  lib,
  inputs ? {},
  variables,
  ...
}:

let
  # Helper function for conditional packages
  mkIfPkg = cond: pkg: lib.optionals cond [ pkg ];
  
  # Theme colors based on style
  themeColors = if variables.theme.style == "dark" then {
    bg = "#1a1b26";
    fg = "#c0caf5";
    accent = "#7aa2f7";
    success = "#9ece6a";
    warning = "#e0af68";
    error = "#f7768e";
  } else {
    bg = "#eff1f5";
    fg = "#4c4f69";
    accent = "#1e66f5";
    success = "#40a02b";
    warning = "#df8e1d";
    error = "#d20f39";
  };
in
{
  # ═══════════════════════════════════════════════════════════════════════════
  # HOME MANAGER SETTINGS
  # ═══════════════════════════════════════════════════════════════════════════

  home = {
    username = variables.username;
    homeDirectory = "/home/${variables.username}";
    stateVersion = variables.stateVersion;

    # Extra directories to create
    file = {
      ".config/nixpkgs/config.nix".text = ''
        { allowUnfree = true; }
      '';
      ".local/share/applications".source = config.lib.file.mkOutOfStoreSymlink 
        "${config.home.homeDirectory}/.local/share/applications";
    };

    # Session variables
    sessionVariables = {
      EDITOR = variables.editor;
      VISUAL = variables.editor;
      BROWSER = variables.browser;
      TERMINAL = variables.terminal;
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
      XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      GOPATH = "${config.xdg.dataHome}/go";
      PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
      LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
      WGETRC = "${config.xdg.configHome}/wget/wgetrc";
      INPUTRC = "${config.xdg.configHome}/readline/inputrc";
    };

    # Session path
    sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.xdg.dataHome}/npm/bin"
      "${config.xdg.dataHome}/cargo/bin"
      "${config.xdg.dataHome}/go/bin"
    ];
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # USER PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════

  home.packages = with pkgs; lib.flatten [
    # ═════════════════════════════════════════════════════════════════════════
    # Browsers
    # ═════════════════════════════════════════════════════════════════════════
    (if variables.browser == "chromium" then chromium
     else if variables.browser == "firefox" then firefox
     else if variables.browser == "brave" then brave
     else if variables.browser == "librewolf" then librewolf
     else if variables.browser == "qutebrowser" then qutebrowser
     else chromium)
    
    # Browser extensions/tools
    (mkIfPkg (variables.browser == "firefox") firefox-extensions.ublock-origin)
    
    # ═════════════════════════════════════════════════════════════════════════
    # Development
    # ═════════════════════════════════════════════════════════════════════════
    (if variables.editor == "vscodium" then vscodium
     else if variables.editor == "vscode" then vscode
     else if variables.editor == "neovim" then neovim
     else if variables.editor == "vim" then vim
     else if variables.editor == "helix" then helix
     else if variables.editor == "emacs" then emacs
     else vscodium)
    
    # Language support
    nodejs_20
    python3
    rustc
    cargo
    go
    lua
    nixd
    nixpkgs-fmt
    alejandra
    
    # Version managers
    fnm  # Fast Node Manager
    
    # Development tools
    git-credential-manager
    gh  # GitHub CLI
    lazygit
    gitui
    difftastic
    tokei  # Code statistics
    hyperfine  # Benchmarking
    just  # Command runner
    
    # ═════════════════════════════════════════════════════════════════════════
    # Terminal
    # ═════════════════════════════════════════════════════════════════════════
    (if variables.terminal == "kitty" then kitty
     else if variables.terminal == "alacritty" then alacritty
     else if variables.terminal == "wezterm" then wezterm
     else if variables.terminal == "foot" then foot
     else if variables.terminal == "ghostty" then ghostty
     else kitty)
    
    # Terminal multiplexers
    tmux
    zellij
    
    # ═════════════════════════════════════════════════════════════════════════
    # Communication
    # ═════════════════════════════════════════════════════════════════════════
    (mkIfPkg variables.apps.discord discord)
    (mkIfPkg variables.apps.discord discord-canary)
    (mkIfPkg variables.apps.telegram telegram-desktop)
    (mkIfPkg variables.apps.slack slack)
    (mkIfPkg variables.apps.thunderbird thunderbird)
    (mkIfPkg variables.apps.element element-desktop)
    
    # ═════════════════════════════════════════════════════════════════════════
    # Media
    # ═════════════════════════════════════════════════════════════════════════
    (mkIfPkg variables.apps.vlc vlc)
    (mkIfPkg variables.apps.mpv mpv)
    (mkIfPkg variables.apps.spotify spotify)
    (mkIfPkg variables.apps.obs obs-studio)
    (mkIfPkg variables.apps.ffmpeg ffmpeg)
    
    # Image editing
    (mkIfPkg variables.apps.gimp gimp)
    (mkIfPkg variables.apps.inkscape inkscape)
    (mkIfPkg variables.apps.krita krita)
    
    # ═════════════════════════════════════════════════════════════════════════
    # Office & Productivity
    # ═════════════════════════════════════════════════════════════════════════
    (mkIfPkg variables.apps.libreoffice libreoffice-qt6-fresh)
    obsidian
    zathura  # PDF viewer
    
    # ═════════════════════════════════════════════════════════════════════════
    # Utilities
    # ═════════════════════════════════════════════════════════════════════════
    gnome-calculator
    gnome-disk-utility
    baobab  # Disk usage analyzer
    gnome-system-monitor
    file-roller
    
    # Clipboard managers
    (mkIfPkg (variables.desktopEnvironment == "hyprland") wl-clipboard)
    (mkIfPkg (variables.desktopEnvironment == "hyprland") cliphist)
    
    # Screenshot tools
    (mkIfPkg (variables.desktopEnvironment == "hyprland") grimblast)
    (mkIfPkg (variables.desktopEnvironment == "hyprland") swappy)
    
    # Notification daemon
    (mkIfPkg (variables.desktopEnvironment == "hyprland") mako)
    (mkIfPkg (variables.desktopEnvironment == "hyprland") libnotify)
    
    # ═════════════════════════════════════════════════════════════════════════
    # Gaming
    # ═════════════════════════════════════════════════════════════════════════
    (mkIfPkg variables.gaming.steam steam)
    (mkIfPkg variables.gaming.lutris lutris)
    (mkIfPkg variables.gaming.heroic heroic)
    (mkIfPkg variables.gaming.prismLauncher prismlauncher)
    (mkIfPkg variables.gaming.mangohud mangohud)
    
    # ═════════════════════════════════════════════════════════════════════════
    # System Tools
    # ═════════════════════════════════════════════════════════════════════════
    pavucontrol  # PulseAudio volume control
    qpwgraph  # PipeWire graph editor
    blueman  # Bluetooth manager
    networkmanagerapplet
    
    # File managers
    nautilus  # GNOME Files
    nemo  # Cinnamon Files
    
    # Archive tools
    p7zip
    unzip
    unrar
    
    # ═════════════════════════════════════════════════════════════════════════
    # Fun & Extras
    # ═════════════════════════════════════════════════════════════════════════
    (mkIfPkg variables.extras.cava cava)  # Audio visualizer
    (mkIfPkg variables.extras.pipes pipes)  # Pipe screensaver
    (mkIfPkg variables.extras.cmatrix cmatrix)
    (mkIfPkg variables.extras.asciiquarium asciiquarium)
    
    # ═════════════════════════════════════════════════════════════════════════
    # Fonts
    # ═════════════════════════════════════════════════════════════════════════
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "NerdFontsSymbolsOnly" ]; })
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # GIT CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    
    userName = variables.fullName;
    userEmail = variables.email;
    
    extraConfig = {
      init.defaultBranch = variables.git.defaultBranch;
      commit.gpgsign = variables.git.gpgSign;
      user.signingkey = lib.mkIf variables.git.gpgSign variables.git.gpgKey;
      core = {
        editor = variables.editor;
        autocrlf = "input";
        whitespace = "trailing-space,space-before-tab";
        fsmonitor = true;
        untrackedCache = true;
      };
      push = {
        autoSetupRemote = true;
        default = "simple";
      };
      pull = {
        rebase = variables.git.pullRebase;
        ff = "only";
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      log.date = "iso";
      column.ui = "auto";
      sequence.editor = "interactive-rebase-tool";
      help.autocorrect = "prompt";
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      url = {
        "https://github.com/".insteadOf = [ "gh:" "github:" ];
        "https://gitlab.com/".insteadOf = [ "gl:" "gitlab:" ];
      };
    };

    aliases = {
      # Basic
      st = "status -sb";
      co = "checkout";
      br = "branch";
      ci = "commit";
      cp = "cherry-pick";
      
      # Information
      last = "log -1 HEAD --stat";
      visual = "log --graph --oneline --all --decorate";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      whoami = "config user.email";
      
      # Undo
      unstage = "reset HEAD --";
      undo = "reset --soft HEAD~1";
      amend = "commit --amend --no-edit";
      
      # Branch management
      bd = "branch -d";
      bD = "branch -D";
      bm = "branch -m";
      
      # Stash
      ss = "stash save";
      sp = "stash pop";
      sl = "stash list";
      sa = "stash apply";
      
      # Remote
      rv = "remote -v";
      pl = "pull";
      ps = "push";
      pf = "push --force-with-lease";
      
      # Worktree
      wa = "worktree add";
      wr = "worktree remove";
      wl = "worktree list";
    };

    ignores = [
      # IDEs
      ".idea/"
      ".vscode/"
      "*.swp"
      "*.swo"
      "*~"
      ".DS_Store"
      
      # Build artifacts
      "build/"
      "dist/"
      "target/"
      "node_modules/"
      ".cache/"
      
      # Logs
      "*.log"
      "logs/"
      
      # Environment
      ".env"
      ".env.local"
      ".env.*.local"
      
      # Temporary files
      "tmp/"
      "temp/"
      "*.tmp"
      "*.temp"
    ];

    delta = {
      enable = true;
      options = {
        features = "side-by-side line-numbers decorations";
        syntax-theme = variables.theme.style;
        plus-style = "syntax #003800";
        minus-style = "syntax #380000";
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-style = "bold yellow ul";
          file-decoration-style = "none";
          hunk-header-decoration-style = "cyan box ul";
        };
        line-numbers = {
          line-numbers-left-style = "cyan";
          line-numbers-right-style = "cyan";
          line-numbers-minus-style = "124";
          line-numbers-plus-style = "28";
        };
      };
    };

    lfs.enable = true;
  };

  # Git credential manager
  programs.git-credential-oauth.enable = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # SHELL CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════

  # Common shell aliases
  home.shellAliases = {
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "~" = "cd ~";
    "-" = "cd -";
    
    # List
    ls = "eza --icons --group-directories-first";
    l = "eza --icons --group-directories-first";
    la = "eza -a --icons --group-directories-first";
    ll = "eza -lah --icons --group-directories-first";
    lt = "eza --tree --icons";
    llt = "eza -lah --tree --icons";
    
    # File operations
    cat = "bat --paging=never";
    less = "bat";
    grep = "rg";
    find = "fd";
    du = "dust";
    df = "duf";
    ps = "procs";
    top = "btop";
    htop = "btop";
    
    # Nix
    rebuild = "nh os switch";
    update = "nh os switch --update";
    nix-clean = "nix-collect-garbage -d";
    nix-search = "nix search nixpkgs";
    nix-info = "nix-shell -p nix-info --run 'nix-info -m'";
    
    # Git shortcuts
    g = "git";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gl = "git pull";
    gd = "git diff";
    
    # Utilities
    c = "clear";
    q = "exit";
    ":q" = "exit";
    
    # Safety
    rm = "rm -i";
    cp = "cp -i";
    mv = "mv -i";
    mkdir = "mkdir -p";
    
    # Archives
    untar = "tar -xvf";
    untargz = "tar -xzvf";
    ungz = "gunzip";
    
    # Network
    ip = "ip -color=auto";
    ping = "ping -c 5";
    ports = "ss -tulanp";
    
    # Editor
    v = variables.editor;
    vi = variables.editor;
    vim = variables.editor;
    
    # System
    shutdown = "systemctl poweroff";
    reboot = "systemctl reboot";
    suspend = "systemctl suspend";
  };

  programs.bash = lib.mkIf (variables.defaultShell == "bash") {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    
    bashrcExtra = ''
      # History settings
      HISTSIZE=100000
      HISTFILESIZE=100000
      HISTCONTROL=ignoreboth:erasedups
      HISTIGNORE="ls:ll:cd:exit:clear:history"
      shopt -s histappend
      shopt -s cmdhist
      
      # Better directory navigation
      shopt -s autocd
      shopt -s dirspell
      shopt -s cdspell
      
      # Check window size after each command
      shopt -s checkwinsize
      
      # Enable globstar
      shopt -s globstar 2>/dev/null
      
      # FZF integration
      if command -v fzf &> /dev/null; then
        eval "$(fzf --bash)"
      fi
      
      # Zoxide integration
      if command -v zoxide &> /dev/null; then
        eval "$(zoxide init bash)"
      fi
    '';
  };

  programs.fish = lib.mkIf (variables.defaultShell == "fish") {
    enable = true;
    
    interactiveShellInit = ''
      # Disable greeting
      set -g fish_greeting
      
      # Vi mode
      fish_vi_key_bindings
      
      # FZF integration
      if command -v fzf &> /dev/null
        fzf --fish | source
      end
      
      # Zoxide integration
      if command -v zoxide &> /dev/null
        zoxide init fish | source
      end
    '';
    
    plugins = [
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
      { name = "sponge"; src = pkgs.fishPlugins.sponge.src; }
    ];
  };

  programs.zsh = lib.mkIf (variables.defaultShell == "zsh") {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    
    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = true;
      extended = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    
    initExtra = ''
      # Better history search
      bindkey "^[[A" history-search-backward
      bindkey "^[[B" history-search-forward
      
      # FZF integration
      if command -v fzf &> /dev/null; then
        eval "$(fzf --zsh)"
      fi
      
      # Zoxide integration
      if command -v zoxide &> /dev/null; then
        eval "$(zoxide init zsh)"
      fi
      
      # Directory navigation
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_SILENT
    '';
    
    oh-my-zsh = {
      enable = true;
      theme = variables.zsh.theme;
      customPkgs = [ pkgs.zsh-autosuggestions pkgs.zsh-syntax-highlighting ];
      plugins = [ 
        "git" 
        "sudo" 
        "z" 
        "extract" 
        "copypath" 
        "copyfile" 
        "copybuffer"
        "dirhistory"
        "history"
        "command-not-found"
      ] ++ variables.zsh.extraPlugins;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # STARSHIP PROMPT
  # ═══════════════════════════════════════════════════════════════════════════

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    
    settings = {
      add_newline = false;
      command_timeout = 1000;
      
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$nix_shell"
        "$container"
        "$line_break"
        "$character"
      ];
      
      character = {
        success_symbol = "[➜](bold ${themeColors.success})";
        error_symbol = "[✗](bold ${themeColors.error})";
        vicmd_symbol = "[❮](bold ${themeColors.accent})";
      };
      
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[📁 $path]($style)[$read_only]($read_only_style) ";
        style = "bold ${themeColors.accent}";
        read_only = " 🔒";
        read_only_style = "${themeColors.warning}";
      };
      
      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = "🌱 ";
        style = "bold ${themeColors.success}";
      };
      
      git_status = {
        format = "([$all_status$ahead_behind]($style)) ";
        style = "${themeColors.warning}";
        ahead = "⇡$count";
        behind = "⇣$count";
        diverged = "⇡$ahead_count⇣$behind_count";
        staged = "+$count";
        modified = "!$count";
        untracked = "?$count";
        deleted = "✘$count";
      };
      
      nix_shell = {
        format = "[$symbol$state]($style) ";
        symbol = "❄️ ";
        style = "bold cyan";
        heuristic = true;
      };
      
      container = {
        format = "[$symbol $name]($style) ";
        symbol = "⬢";
        style = "bold red dimmed";
      };
      
      username = {
        format = "[$user]($style) ";
        style_user = "${themeColors.fg}";
        show_always = false;
      };
      
      hostname = {
        format = "[$hostname]($style) ";
        style = "dimmed ${themeColors.fg}";
        ssh_only = true;
      };
      
      line_break = {
        disabled = false;
      };
      
      # Disable unused modules
      aws.disabled = true;
      gcloud.disabled = true;
      azure.disabled = true;
      kubernetes.disabled = true;
      terraform.disabled = true;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # FZF - Fuzzy Finder
  # ═══════════════════════════════════════════════════════════════════════════

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
      "--bind 'ctrl-/:toggle-preview'"
    ];
    
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetOptions = [ "--preview 'bat --color=always --style=numbers {}'" ];
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    changeDirWidgetOptions = [ "--preview 'eza --tree --level=2 --icons {}'" ];
    historyWidgetOptions = [ "--sort" "--exact" ];
    
    colors = if variables.theme.style == "dark" then {
      bg = "#1a1b26";
      "bg+" = "#24283b";
      fg = "#c0caf5";
      "fg+" = "#a9b1d6";
      hl = "#7aa2f7";
      "hl+" = "#7aa2f7";
      info = "#e0af68";
      prompt = "#7aa2f7";
      pointer = "#bb9af7";
      marker = "#9ece6a";
      spinner = "#e0af68";
      header = "#73daca";
    } else {
      bg = "#eff1f5";
      "bg+" = "#e6e9ef";
      fg = "#4c4f69";
      "fg+" = "#5c5f77";
      hl = "#1e66f5";
      "hl+" = "#1e66f5";
      info = "#df8e1d";
      prompt = "#1e66f5";
      pointer = "#8839ef";
      marker = "#40a02b";
      spinner = "#df8e1d";
      header = "#179299";
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # ZOXIDE - Smarter cd
  # ═══════════════════════════════════════════════════════════════════════════

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # BAT - Better cat
  # ═══════════════════════════════════════════════════════════════════════════

  programs.bat = {
    enable = true;
    config = {
      theme = if variables.theme.style == "dark" then "TwoDark" else "GitHub";
      style = "numbers,changes,grid";
      paging = "never";
    };
    extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch ];  };

  # ═══════════════════════════════════════════════════════════════════════════
  # EZA - Better ls
  # ═══════════════════════════════════════════════════════════════════════════

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--time-style=long-iso"
    ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # BTOP - System monitor
  # ═══════════════════════════════════════════════════════════════════════════

  programs.btop = {
    enable = true;
    settings = {
      color_theme = if variables.theme.style == "dark" then "tokyo-night" else "solarized_light";
      theme_background = false;
      vim_keys = true;
      rounded_corners = true;
      graph_symbol = "braille";
      presets = "cpu:1:default,mem:2:default,net:3:default";
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # LAZYGIT - TUI for git
  # ═══════════════════════════════════════════════════════════════════════════

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          activeBorderColor = [ "#7aa2f7" "bold" ];
          inactiveBorderColor = [ "#565f89" ];
          optionsTextColor = [ "#7aa2f7" ];
          selectedLineBgColor = [ "#283457" ];
          cherryPickedCommitBgColor = [ "#283457" ];
          cherryPickedCommitFgColor = [ "#7aa2f7" ];
          unstagedChangesColor = [ "#f7768e" ];
          defaultFgColor = [ "#c0caf5" ];
        };
        showFileTree = true;
        showListFooter = false;
        showRandomTip = false;
        showBottomLine = false;
        showCommandLog = false;
        showIcons = true;
      };
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
        commit = {
          signOff = false;
        };
        log = {
          showGraph = "always";
          showWholeGraph = false;
        };
      };
      update.method = "never";
      os.editPreset = variables.editor;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # TMUX - Terminal multiplexer
  # ═══════════════════════════════════════════════════════════════════════════

  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";
    
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour '${if variables.theme.style == "dark" then "mocha" else "latte"}'
          set -g @catppuccin_window_status_enable "yes"
          set -g @catppuccin_window_status_icon_enable "yes"
        '';
      }
    ];
    
    extraConfig = ''
      # Better split bindings
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
      
      # Better pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # Better pane resizing
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      
      # Copy mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      
      # Status bar
      set -g status-position top
      set -g status-interval 5
      
      # True color support
      set -ag terminal-overrides ",$TERM:RGB"
      
      # Focus events
      set -g focus-events on
      
      # Renumber windows
      set -g renumber-windows on
      
      # Monitor activity
      setw -g monitor-activity on
      set -g visual-activity off
      
      # Clock
      setw -g clock-mode-colour colour4
    '';
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # ZELLIJ - Modern terminal multiplexer (alternative to tmux)
  # ═══════════════════════════════════════════════════════════════════════════

  programs.zellij = {
    enable = variables.terminalMultiplexer == "zellij";
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    
    settings = {
      theme = if variables.theme.style == "dark" then "tokyo-night" else "catppuccin-latte";
      default_layout = "compact";
      pane_frames = false;
      simplified_ui = true;
      mouse_mode = true;
      copy_clipboard = "system";
      copy_on_select = true;
      scrollback_editor = variables.editor;
      ui.pane_frames.hide_session_name = true;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # DIRENV - Directory-specific environments
  # ═══════════════════════════════════════════════════════════════════════════

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    
    config = {
      global = {
        load_dotenv = true;
        strict_env = true;
      };
      whitelist = {
        prefix = [ 
          "${config.home.homeDirectory}/projects"
          "${config.home.homeDirectory}/work"
        ];
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # GPG
  # ═══════════════════════════════════════════════════════════════════════════

  programs.gpg = {
    enable = true;
    settings = {
      personal-digest-preferences = "SHA512";
      cert-digest-algo = "SHA512";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      keyid-format = "0xlong";
      with-fingerprint = true;
      with-colons = true;
      fixed-list-mode = true;
      no-comments = true;
      no-emit-version = true;
      no-greeting = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    defaultCacheTtl = 3600;
    maxCacheTtl = 7200;
    enableSshSupport = true;
    sshKeys = variables.gpg.sshKeys;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SSH
  # ═══════════════════════════════════════════════════════════════════════════

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "${config.home.homeDirectory}/.ssh/github";
        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };
      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = "${config.home.homeDirectory}/.ssh/gitlab";
      };
    };
    extraConfig = ''
      Host *
        IdentitiesOnly yes
        ServerAliveInterval 60
        ServerAliveCountMax 3
    '';
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # TERMINAL EMULATORS
  # ═══════════════════════════════════════════════════════════════════════════

  programs.kitty = lib.mkIf (variables.terminal == "kitty") {
    enable = true;
    
    theme = if variables.theme.style == "dark" then "Tokyo Night" else "Catppuccin-Latte";
    
    settings = {
      # Font
      font_family = variables.theme.font.mono;
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = variables.theme.font.size;
      
      # Cursor
      cursor_shape = "block";
      cursor_blink_interval = 0;
      cursor_stop_blinking_after = 0;
      
      # Scrollback
      scrollback_lines = 10000;
      scrollback_pager = "less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER";
      
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
      
      # Bell
      enable_audio_bell = false;
      visual_bell_duration = 0.0;
      window_alert_on_bell = true;
      bell_on_tab = true;
      
      # Window
      remember_window_size = true;
      initial_window_width = 120c;
      initial_window_height = 40c;
      window_padding_width = 8;
      window_margin_width = 0;
      
      # Tabs
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
      
      # Layout
      enabled_layouts = "*";
      
      # Colors
      background_opacity = "0.95";
      background_blur = 0;
      
      # Mouse
      mouse_hide_wait = 3.0;
      focus_follows_mouse = true;
      
      # URLs
      url_style = "curly";
      url_color = "#0087bd";
      detect_urls = true;
      
      # Clipboard
      copy_on_select = true;
      strip_trailing_spaces = "smart";
      
      # Shell integration
      shell_integration = "enabled";
      
      # macOS specific
      macos_option_as_alt = "both";
      macos_hide_from_tasks = false;
      macos_quit_when_last_window_closed = false;
      macos_window_resizable = true;
      
      # Advanced
      update_check_interval = 0;
      allow_remote_control = true;
      listen_on = "unix:/tmp/kitty";
    };
    
    keybindings = {
      # Tabs
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+1" = "goto_tab 1";
      "ctrl+shift+2" = "goto_tab 2";
      "ctrl+shift+3" = "goto_tab 3";
      "ctrl+shift+4" = "goto_tab 4";
      "ctrl+shift+5" = "goto_tab 5";
      
      # Windows
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";
      "ctrl+shift+f" = "move_window_forward";
      "ctrl+shift+b" = "move_window_backward";
      "ctrl+shift+`" = "move_window_to_top";
      "ctrl+shift+r" = "start_resizing_window";
      
      # Layouts
      "ctrl+shift+l" = "next_layout";
      
      # Font size
      "ctrl+shift+equal" = "increase_font_size";
      "ctrl+shift+minus" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";
      
      # Clipboard
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+s" = "paste_from_selection";
      
      # Scrollback
      "ctrl+shift+h" = "show_scrollback";
      "ctrl+shift+g" = "show_last_command_output";
      
      # Misc
      "ctrl+shift+e" = "kitten hints";
      "ctrl+shift+p>f" = "kitten hints --type path --program -";
      "ctrl+shift+p>shift+f" = "kitten hints --type path";
      "ctrl+shift+p>l" = "kitten hints --type line --program -";
      "ctrl+shift+p>w" = "kitten hints --type word --program -";
      "ctrl+shift+p>h" = "kitten hints --type hash --program -";
      "ctrl+shift+p>n" = "kitten hints --type linenum";
      "ctrl+shift+p>y" = "kitten hints --type hyperlink";
    };
    
    extraConfig = ''
      # Include local config if it exists
      include ${config.xdg.configHome}/kitty/local.conf
    '';
  };

  programs.alacritty = lib.mkIf (variables.terminal == "alacritty") {
    enable = true;
    
    settings = {
      font = {
        normal.family = variables.theme.font.mono;
        bold.family = variables.theme.font.mono;
        italic.family = variables.theme.font.mono;
        bold_italic.family = variables.theme.font.mono;
        size = variables.theme.font.size;
      };
      
      window = {
        opacity = 0.95;
        padding = {
          x = 8;
          y = 8;
        };
        decorations = "full";
        startup_mode = "Windowed";
        dynamic_title = true;
      };
      
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      
      cursor = {
        style = "Block";
        unfocused_hollow = true;
        thickness = 0.15;
      };
      
      mouse = {
        double_click = {
          threshold = 300;
        };
        triple_click = {
          threshold = 300;
        };
        hide_when_typing = true;
      };
      
      selection = {
        semantic_escape_chars = ",│`|:"'"' ()[]{}<>";
        save_to_clipboard = true;
      };
      
      keyboard = {
        bindings = [
          { key = "V"; mods = "Control|Shift"; action = "Paste"; }
          { key = "C"; mods = "Control|Shift"; action = "Copy"; }
          { key = "Insert"; mods = "Shift"; action = "PasteSelection"; }
          { key = "Key0"; mods = "Control"; action = "ResetFontSize"; }
          { key = "Equals"; mods = "Control"; action = "IncreaseFontSize"; }
          { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
        ];
      };
      
      colors = if variables.theme.style == "dark" then {
        primary = {
          background = "#1a1b26";
          foreground = "#c0caf5";
        };
        cursor = {
          text = "#1a1b26";
          cursor = "#c0caf5";
        };
        selection = {
          text = "CellForeground";
          background = "#283457";
        };
        normal = {
          black = "#15161e";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#a9b1d6";
        };
        bright = {
          black = "#414868";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#c0caf5";
        };
      } else {
        primary = {
          background = "#eff1f5";
          foreground = "#4c4f69";
        };
        cursor = {
          text = "#eff1f5";
          cursor = "#4c4f69";
        };
        selection = {
          text = "CellForeground";
          background = "#ccd0da";
        };
        normal = {
          black = "#5c5f77";
          red = "#d20f39";
          green = "#40a02b";
          yellow = "#df8e1d";
          blue = "#1e66f5";
          magenta = "#8839ef";
          cyan = "#179299";
          white = "#acb0be";
        };
        bright = {
          black = "#6c6f85";
          red = "#d20f39";
          green = "#40a02b";
          yellow = "#df8e1d";
          blue = "#1e66f5";
          magenta = "#8839ef";
          cyan = "#179299";
          white = "#bcc0cc";
        };
      };
    };
  };

  programs.wezterm = lib.mkIf (variables.terminal == "wezterm") {
    enable = true;
    
    extraConfig = ''
      local wezterm = require 'wezterm'
      local config = {}
      
      -- Font
      config.font = wezterm.font '${variables.theme.font.mono}'
      config.font_size = ${toString variables.theme.font.size}
      
      -- Color scheme
      config.color_scheme = '${if variables.theme.style == "dark" then "Tokyo Night" else "Catppuccin Latte"}'
      
      -- Window
      config.window_background_opacity = 0.95
      config.window_padding = {
        left = 8,
        right = 8,
        top = 8,
        bottom = 8,
      }
      config.window_decorations = 'RESIZE'
      config.hide_tab_bar_if_only_one_tab = true
      
      -- Cursor
      config.default_cursor_style = 'BlinkingBlock'
      config.cursor_blink_rate = 500
      
      -- Scrollback
      config.scrollback_lines = 10000
      
      -- Enable wayland on Linux
      config.enable_wayland = true
      
      -- Tab bar
      config.use_fancy_tab_bar = true
      config.tab_bar_at_bottom = false
      
      -- Key bindings
      config.keys = {
        {
          key = 't',
          mods = 'CTRL|SHIFT',
          action = wezterm.action.SpawnTab 'CurrentPaneDomain',
        },
        {
          key = 'w',
          mods = 'CTRL|SHIFT',
          action = wezterm.action.CloseCurrentTab { confirm = true },
        },
        {
          key = 'RightArrow',
          mods = 'CTRL|SHIFT',
          action = wezterm.action.ActivateTabRelative(1),
        },
        {
          key = 'LeftArrow',
          mods = 'CTRL|SHIFT',
          action = wezterm.action.ActivateTabRelative(-1),
        },
      }
      
      return config
    '';
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # EDITORS
  # ═══════════════════════════════════════════════════════════════════════════

  # Neovim
  programs.neovim = lib.mkIf (variables.editor == "neovim") {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      # Essential
      nvim-treesitter
      nvim-treesitter.withAllGrammars
      plenary-nvim
      
      # LSP
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      
      # UI
      telescope-nvim
      nvim-tree-lua
      lualine-nvim
      bufferline-nvim
      nvim-web-devicons
      
      # Themes
      tokyonight-nvim
      catppuccin-nvim
      
      # Editing
      nvim-autopairs
      comment-nvim
      gitsigns-nvim
      indent-blankline-nvim
      
      # Navigation
      which-key-nvim
      vim-tmux-navigator
    ];
    
    extraConfig = ''
      -- Basic settings
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.mouse = 'a'
      vim.opt.clipboard = 'unnamedplus'
      vim.opt.breakindent = true
      vim.opt.undofile = true
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.signcolumn = 'yes'
      vim.opt.updatetime = 250
      vim.opt.timeoutlen = 300
      vim.opt.splitright = true
      vim.opt.splitbelow = true
      vim.opt.list = true
      vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
      vim.opt.inccommand = 'split'
      vim.opt.cursorline = true
      vim.opt.scrolloff = 10
      vim.opt.hlsearch = true
      
      -- Theme
      vim.cmd[[colorscheme ${if variables.theme.style == "dark" then "tokyonight-night" else "catppuccin-latte"}]]
      
      -- Keymaps
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '
      
      -- Telescope
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
      
      -- Nvim-tree
      require('nvim-tree').setup()
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', {})
      
      -- Lualine
      require('lualine').setup {
        options = {
          theme = '${if variables.theme.style == "dark" then "tokyonight" else "catppuccin"}'
        }
      }
      
      -- Treesitter
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        indent = { enable = true },
      }
      
      -- LSP
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      -- Enable LSP servers
      local servers = { 'nixd', 'rust_analyzer', 'tsserver', 'pyright', 'gopls', 'lua_ls' }
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          capabilities = capabilities,
        }
      end
      
      -- Completion
      local cmp = require('cmp')
      cmp.setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm { select = true },
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
      }
      
      -- Autopairs
      require('nvim-autopairs').setup {}
      
      -- Comments
      require('Comment').setup()
      
      -- Gitsigns
      require('gitsigns').setup()
      
      -- Indent blankline
      require('ibl').setup()
      
      -- Which-key
      require('which-key').setup {}
    '';
  };

  # Helix
  programs.helix = lib.mkIf (variables.editor == "helix") {
    enable = true;
    defaultEditor = true;
    
    settings = {
      theme = if variables.theme.style == "dark" then "tokyonight" else "catppuccin_latte";
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        bufferline = "multiple";
        rulers = [ 80 120 ];
        indent-guides.render = true;
        soft-wrap.enable = true;
        completion-trigger-len = 1;
        auto-save = true;
        auto-format = true;
        idle-timeout = 0;
        mouse = true;
        true-color = true;
      };
      keys.normal = {
        space.space = "file_picker";
        space.w = ":w";
        space.q = ":q";
        "C-s" = ":w";
        "C-q" = ":q";
        "#" = "toggle_comments";
        esc = [ "collapse_selection" "keep_primary_selection" ];
      };
    };
    
    languages = {
      language-server.nixd = {
        command = "nixd";
      };
      language = [
        {
          name = "nix";
          language-servers = [ "nixd" ];
          formatter.command = "alejandra";
          auto-format = true;
        }
        {
          name = "rust";
          auto-format = true;
        }
        {
          name = "python";
          auto-format = true;
        }
        {
          name = "javascript";
          auto-format = true;
        }
        {
          name = "typescript";
          auto-format = true;
        }
        {
          name = "go";
          auto-format = true;
        }
      ];
    };
  };

  # VSCodium
  programs.vscode = lib.mkIf (variables.editor == "vscodium" || variables.editor == "vscode") {
    enable = true;
    package = if variables.editor == "vscodium" then pkgs.vscodium else pkgs.vscode;
    
    userSettings = {
      # Theme
      "workbench.colorTheme" = if variables.theme.style == "dark" then "Tokyo Night" else "GitHub Light";
      "workbench.iconTheme" = "material-icon-theme";
      
      # Font
      "editor.fontFamily" = "'${variables.theme.font.mono}', 'monospace'";
      "editor.fontSize" = 13;
      "editor.fontLigatures" = true;
      "terminal.integrated.fontFamily" = "'${variables.theme.font.mono}'";
      "terminal.integrated.fontSize" = 12;
      
      # Editor behavior
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
      "editor.minimap.enabled" = false;
      "editor.lineNumbers" = "relative";
      "editor.cursorBlinking" = "solid";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.smoothScrolling" = true;
      "editor.scrollBeyondLastLine" = false;
      "editor.wordWrap" = "on";
      "editor.rulers" = [ 80 120 ];
      "editor.tabSize" = 2;
      "editor.insertSpaces" = true;
      "editor.detectIndentation" = true;
      "editor.trimAutoWhitespace" = true;
      "editor.renderWhitespace" = "boundary";
      "editor.guides.indentation" = true;
      "editor.bracketPairColorization.enabled" = true;
      "editor.guides.bracketPairs" = "active";
      
      # Files
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 1000;
      "files.trimTrailingWhitespace" = true;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.exclude" = {
        "**/.git" = true;
        "**/.DS_Store" = true;
        "**/node_modules" = true;
        "**/target" = true;
        "**/build" = true;
        "**/dist" = true;
      };
      
      # Search
      "search.exclude" = {
        "**/node_modules" = true;
        "**/target" = true;
        "**/build" = true;
        "**/dist" = true;
        "**/.git" = true;
      };
      
      # Terminal
      "terminal.integrated.defaultProfile.linux" = variables.defaultShell;
      "terminal.integrated.cursorBlinking" = false;
      "terminal.integrated.cursorStyle" = "block";
      "terminal.integrated.scrollback" = 10000;
      "terminal.integrated.enablePersistentSessions" = true;
      
      # Git
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;
      "git.openRepositoryInParentFolders" = "always";
      "scm.defaultViewMode" = "tree";
      
      # Extensions
      "extensions.autoCheckUpdates" = false;
      "extensions.autoUpdate" = false;
      
      # Telemetry
      "telemetry.telemetryLevel" = "off";
      "workbench.enableExperiments" = false;
      "workbench.settings.enableNaturalLanguageSearch" = false;
      
      # Updates
      "update.mode" = "none";
      "update.showReleaseNotes" = false;
      
      # Window
      "window.restoreWindows" = "none";
      "window.newWindowDimensions" = "inherit";
      "workbench.startupEditor" = "none";
      "workbench.editor.enablePreview" = false;
      "workbench.editor.tabSizing" = "shrink";
      "breadcrumbs.enabled" = true;
      
      # Nix
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.formatterPath" = "alejandra";
      "[nix]".editor.defaultFormatter = "jnoortheen.nix-ide";
      
      # Language specific
      "[javascript]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[typescript]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[json]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[rust]".editor.defaultFormatter = "rust-lang.rust-analyzer";
      "[python]".editor.defaultFormatter = "ms-python.black-formatter";
      "[go]".editor.defaultFormatter = "golang.go";
      
      # Prettier
      "prettier.singleQuote" = true;
      "prettier.trailingComma" = "es5";
      "prettier.tabWidth" = 2;
      "prettier.semi" = true;
      
      # ESLint
      "eslint.format.enable" = true;
      "eslint.lintTask.enable" = true;
      
      # Rust
      "rust-analyzer.checkOnSave.command" = "clippy";
      "rust-analyzer.cargo.features" = "all";
      
      # Python
      "python.analysis.typeCheckingMode" = "basic";
      "python.analysis.autoImportCompletions" = true;
      
      # Go
      "gopls" = {
        "formatting.gofumpt" = true;
        "ui.semanticTokens" = true;
      };
      
      # Remote
      "remote.SSH.useLocalServer" = true;
      "remote.SSH.connectTimeout" = 60;
      
      # Explorer
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "explorer.confirmPasteNative" = false;
      "explorer.fileNesting.enabled" = true;
      "explorer.fileNesting.patterns" = {
        "*.ts" = "${'${capture}'}.js, ${'${capture}'}.d.ts, ${'${capture}'}.js.map";
        "*.js" = "${'${capture}'}.js.map, ${'${capture}'}.min.js, ${'${capture}'}.d.ts";
        "*.jsx" = "${'${capture}'}.js";
        "*.tsx" = "${'${capture}'}.ts";
        "tsconfig.json" = "tsconfig.*.json";
        "package.json" = "package-lock.json, yarn.lock, pnpm-lock.yaml, bun.lockb";
        ".eslintrc.*" = ".eslintignore";
        ".prettierrc.*" = ".prettierignore";
        "README*" = "CHANGELOG*, LICENSE*, CONTRIBUTING*";
      };
      
      # Testing
      "testing.autoRun.delay" = 1000;
      
      # Debug
      "debug.console.fontFamily" = "'${variables.theme.font.mono}'";
      "debug.console.fontSize" = 12;
      
      # Comments
      "editor.inlineSuggest.enabled" = true;
    };
    
    keybindings = [
      {
        key = "ctrl+k ctrl+s";
        command = "workbench.action.openGlobalKeybindings";
      }
      {
        key = "ctrl+shift+n";
        command = "workbench.action.newWindow";
      }
      {
        key = "ctrl+shift+w";
        command = "workbench.action.closeWindow";
      }
      {
        key = "ctrl+k ctrl+w";
        command = "workbench.action.closeAllEditors";
      }
      {
        key = "ctrl+tab";
        command = "workbench.action.nextEditor";
      }
      {
        key = "ctrl+shift+tab";
        command = "workbench.action.previousEditor";
      }
      {
        key = "ctrl+1";
        command = "workbench.action.openEditorAtIndex1";
      }
      {
        key = "ctrl+2";
        command = "workbench.action.openEditorAtIndex2";
      }
      {
        key = "ctrl+3";
        command = "workbench.action.openEditorAtIndex3";
      }
      {
        key = "ctrl+4";
        command = "workbench.action.openEditorAtIndex4";
      }
      {
        key = "ctrl+5";
        command = "workbench.action.openEditorAtIndex5";
      }
      {
        key = "ctrl+`";
        command = "workbench.action.terminal.toggleTerminal";
      }
      {
        key = "ctrl+shift+`";
        command = "workbench.action.terminal.new";
      }
      {
        key = "f12";
        command = "editor.action.goToDeclaration";
      }
      {
        key = "ctrl+f12";
        command = "editor.action.goToImplementation";
      }
      {
        key = "shift+f12";
        command = "editor.action.goToReferences";
      }
      {
        key = "ctrl+shift+f";
        command = "workbench.action.findInFiles";
      }
      {
        key = "ctrl+shift+h";
        command = "workbench.action.replaceInFiles";
      }
      {
        key = "ctrl+shift+g";
        command = "workbench.view.scm";
      }
      {
        key = "ctrl+shift+e";
        command = "workbench.view.explorer";
      }
      {
        key = "ctrl+shift+x";
        command = "workbench.view.extensions";
      }
      {
        key = "ctrl+shift+d";
        command = "workbench.view.debug";
      }
      {
        key = "ctrl+shift+u";
        command = "workbench.view.output";
      }
      {
        key = "ctrl+shift+m";
        command = "workbench.view.problems";
      }
      {
        key = "ctrl+shift+y";
        command = "workbench.debug.action.toggleRepl";
      }
      {
        key = "ctrl+shift+o";
        command = "workbench.action.gotoSymbol";
      }
      {
        key = "ctrl+t";
        command = "workbench.action.showAllSymbols";
      }
      {
        key = "ctrl+shift+p";
        command = "workbench.action.showCommands";
      }
      {
        key = "ctrl+p";
        command = "workbench.action.quickOpen";
      }
      {
        key = "ctrl+=";
        command = "editor.action.fontZoomIn";
      }
      {
        key = "ctrl+-";
        command = "editor.action.fontZoomOut";
      }
      {
        key = "ctrl+0";
        command = "editor.action.fontZoomReset";
      }
    ];
    
    extensions = with pkgs.vscode-extensions; [
      # Nix
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      
      # Python
      ms-python.python
      ms-python.vscode-pylance
      ms-python.black-formatter
      ms-python.isort
      
      # Rust
      rust-lang.rust-analyzer
      
      # JavaScript/TypeScript
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      bradlc.vscode-tailwindcss
      
      # Go
      golang.go
      
      # Lua
      sumneko.lua
      
      # General
      github.copilot
      github.copilot-chat
      eamodio.gitlens
      usernamehw.errorlens
      gruntfuggly.todo-tree
      aaron-bond.better-comments
      
      # UI
      pkief.material-icon-theme
      enkia.tokyo-night
      catppuccin.catppuccin-vsc
      
      # Productivity
      formulahendry.auto-rename-tag
      christian-kohler.path-intellisense
      streetsidesoftware.code-spell-checker
      
      # Markdown
      yzhang.markdown-all-in-one
      davidanson.vscode-markdownlint
      
      # YAML/TOML/JSON
      redhat.vscode-yaml
      tamasfe.even-better-toml
      
      # Docker
      ms-azuretools.vscode-docker
      
      # Remote
      ms-vscode-remote.remote-ssh
      
      # Testing
      vitest.explorer
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # Additional extensions not in nixpkgs
      {
        name = "catppuccin-vsc-icons";
        publisher = "catppuccin";
        version = "1.13.0";
        sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      }
    ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # BROWSERS
  # ═══════════════════════════════════════════════════════════════════════════

  programs.firefox = lib.mkIf (variables.browser == "firefox" || variables.browser == "librewolf") {
    enable = true;
    package = if variables.browser == "librewolf" then pkgs.librewolf else pkgs.firefox;
    
    profiles.${variables.username} = {
      name = variables.username;
      isDefault = true;
      
      settings = {
        # Homepage
        "browser.startup.homepage" = "about:home";
        "browser.startup.page" = 1;
        "browser.newtabpage.enabled" = true;
        
        # Privacy
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.partition.network_state.ocsp_cache" = true;
        
        # Search
        "browser.search.defaultenginename" = "DuckDuckGo";
        "browser.search.selectedEngine" = "DuckDuckGo";
        
        # Downloads
        "browser.download.useDownloadDir" = false;
        "browser.download.always_ask_before_handling_new_types" = true;
        
        # UI
        "browser.compactmode.show" = true;
        "browser.uidensity" = 1;
        "browser.tabs.firefox-view" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.urlbar.suggest.bookmark" = true;
        "browser.urlbar.suggest.history" = true;
        "browser.urlbar.suggest.openpage" = true;
        
        # Performance
        "browser.sessionstore.resume_from_crash" = true;
        "browser.sessionstore.interval" = 30000;
        
        # Security
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        
        # Smooth scrolling
        "general.smoothScroll" = true;
        "general.smoothScroll.lines.durationMaxMS" = 125;
        "general.smoothScroll.lines.durationMinMS" = 125;
        "general.smoothScroll.mouseWheel.durationMaxMS" = 200;
        "general.smoothScroll.mouseWheel.durationMinMS" = 100;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "general.smoothScroll.other.durationMaxMS" = 125;
        "general.smoothScroll.other.durationMinMS" = 125;
        "general.smoothScroll.pages.durationMaxMS" = 125;
        "general.smoothScroll.pages.durationMinMS" = 125;
        "mousewheel.min_line_scroll_amount" = 30;
        "mousewheel.system_scroll_override_on_root_content.enabled" = true;
        "mousewheel.system_scroll_override_on_root_content.horizontal.factor" = 175;
        "mousewheel.system_scroll_override_on_root_content.vertical.factor" = 175;
        "toolkit.scrollbox.horizontalScrollDistance" = 6;
        "toolkit.scrollbox.verticalScrollDistance" = 2;
        
        # Hardware acceleration
        "layers.acceleration.force-enabled" = true;
        "gfx.webrender.all" = true;
        "gfx.webrender.enabled" = true;
        "layout.css.backdrop-filter.enabled" = true;
        "svg.context-properties.content.enabled" = true;
        
        # Disable telemetry
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.sessions.current.clean" = true;
        "devtools.onboarding.telemetry.logged" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
      };
      
      search = {
        force = true;
        default = "DuckDuckGo";
        order = [ "DuckDuckGo" "Google" ];
        engines = {
          "DuckDuckGo" = {
            urls = [{
              template = "https://duckduckgo.com/";
              params = [
                { name = "q"; value = "{searchTerms}"; }
              ];
            }];
            definedAliases = [ "@ddg" ];
          };
          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nix" ];
          };
          "NixOS Wiki" = {
            urls = [{
              template = "https://nixos.wiki/index.php?search={searchTerms}";
            }];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@nixwiki" ];
          };
          "Home Manager" = {
            urls = [{
              template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
            }];
            definedAliases = [ "@hm" ];
          };
          "GitHub" = {
            urls = [{
              template = "https://github.com/search?q={searchTerms}&type=repositories";
            }];
            definedAliases = [ "@gh" ];
          };
        };
      };
      
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        darkreader
        vimium
        tree-style-tab
        multi-account-containers
        sidebery
        sponsorblock
        return-youtube-dislike
        indie-wiki-buddy
      ];
      
      userChrome = ''
        /* Hide tab bar when using Tree Style Tab */
        #TabsToolbar {
          visibility: collapse !important;
        }
        
        /* Compact UI */
        :root {
          --tab-min-height: 28px !important;
        }
        
        /* Hide title bar */
        #titlebar {
          appearance: none !important;
        }
      '';
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # XDG (File associations, default apps)
  # ═══════════════════════════════════════════════════════════════════════════

  xdg = {
    enable = true;
    
    configFile = {
      "npm/npmrc".text = ''
        prefix=''${XDG_DATA_HOME}/npm
        cache=''${XDG_CACHE_HOME}/npm
        init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
      '';
      "wget/wgetrc".text = ''
        hsts-file=''${XDG_CACHE_HOME}/wget-hsts
      '';
      "readline/inputrc".text = ''
        set editing-mode vi
        set show-all-if-ambiguous on
        set completion-ignore-case on
      '';
    };
    
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      templates = "${config.home.homeDirectory}/Templates";
      publicShare = "${config.home.homeDirectory}/Public";
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        # Web
        "text/html" = "${variables.browser}.desktop";
        "x-scheme-handler/http" = "${variables.browser}.desktop";
        "x-scheme-handler/https" = "${variables.browser}.desktop";
        "x-scheme-handler/about" = "${variables.browser}.desktop";
        "x-scheme-handler/unknown" = "${variables.browser}.desktop";
        
        # Text
        "text/plain" = "${variables.editor}.desktop";
        "text/markdown" = "${variables.editor}.desktop";
        "text/x-markdown" = "${variables.editor}.desktop";
        
        # Code
        "text/x-python" = "${variables.editor}.desktop";
        "text/javascript" = "${variables.editor}.desktop";
        "text/typescript" = "${variables.editor}.desktop";
        "text/rust" = "${variables.editor}.desktop";
        "text/x-rust" = "${variables.editor}.desktop";
        "text/x-go" = "${variables.editor}.desktop";
        "text/x-shellscript" = "${variables.editor}.desktop";
        
        # Documents
        "application/pdf" = "org.pwmt.zathura.desktop";
        "application/epub+zip" = "org.pwmt.zathura.desktop";
        "application/x-mobipocket-ebook" = "org.pwmt.zathura.desktop";
        
        # Images
        "image/png" = "org.gnome.eog.desktop";
        "image/jpeg" = "org.gnome.eog.desktop";
        "image/gif" = "org.gnome.eog.desktop";
        "image/webp" = "org.gnome.eog.desktop";
        "image/svg+xml" = "org.gnome.eog.desktop";
        
        # Archives
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
        "application/x-rar" = "org.gnome.FileRoller.desktop";
        "application/x-tar" = "org.gnome.FileRoller.desktop";
        "application/gzip" = "org.gnome.FileRoller.desktop";
        
        # Media
        "video/mp4" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
        "audio/mpeg" = "vlc.desktop";
        "audio/ogg" = "vlc.desktop";
        "audio/flac" = "vlc.desktop";
        
        # Office
        "application/vnd.oasis.opendocument.text" = "libreoffice.desktop";
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "libreoffice.desktop";
        "application/vnd.oasis.opendocument.spreadsheet" = "libreoffice.desktop";
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "libreoffice.desktop";
        "application/vnd.oasis.opendocument.presentation" = "libreoffice.desktop";
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "libreoffice.desktop";
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # GTK THEMING
  # ═══════════════════════════════════════════════════════════════════════════

  gtk = {
    enable = true;
    
    theme = {
      name = if variables.theme.style == "dark" then "Catppuccin-Mocha-Compact-Mauve-Dark" else "Catppuccin-Latte-Compact-Mauve-Light";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = if variables.theme.style == "dark" then "mocha" else "latte";
      };
    };
    
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    
    font = {
      name = variables.theme.font.sans;
      size = 11;
    };
    
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = if variables.theme.style == "dark" then 1 else 0;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
      gtk-decoration-layout = "menu:minimize,maximize,close";
    };
    
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = if variables.theme.style == "dark" then 1 else 0;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # QT THEMING
  # ═══════════════════════════════════════════════════════════════════════════

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
      package = pkgs.kvantum;
    };
  };

  # Kvantum theme
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Catppuccin-Mocha-Mauve
  '';

  # ═══════════════════════════════════════════════════════════════════════════
  # CURSOR
  # ═══════════════════════════════════════════════════════════════════════════

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # NOTIFICATIONS
  # ═══════════════════════════════════════════════════════════════════════════

  services.mako = lib.mkIf (variables.desktopEnvironment == "hyprland") {
    enable = true;
    font = "${variables.theme.font.sans} 11";
    padding = "10";
    margin = "10";
    borderSize = 2;
    borderRadius = 8;
    backgroundColor = if variables.theme.style == "dark" then "#1e1e2e" else "#eff1f5";
    textColor = if variables.theme.style == "dark" then "#cdd6f4" else "#4c4f69";
    borderColor = if variables.theme.style == "dark" then "#cba6f7" else "#8839ef";
    progressColor = if variables.theme.style == "dark" then "#313244" else "#ccd0da";
    icons = true;
    maxIconSize = 64;
    defaultTimeout = 5000;
    ignoreTimeout = false;
    maxVisible = 5;
    layer = "overlay";
    anchor = "top-right";
    sort = "+time";
    
    extraConfig = ''
      [urgency=low]
      border-color=#6c7086
      
      [urgency=normal]
      border-color=#cba6f7
      
      [urgency=critical]
      border-color=#f38ba8
      default-timeout=0
    '';
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # CLIPBOARD
  # ═══════════════════════════════════════════════════════════════════════════

  services.clipman = lib.mkIf (variables.desktopEnvironment == "hyprland") {
    enable = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SYNCTHING
  # ═══════════════════════════════════════════════════════════════════════════

  services.syncthing = lib.mkIf variables.sync.syncthing.enable {
    enable = true;
    tray.enable = false;
    
    settings = {
      devices = variables.sync.syncthing.devices;
      folders = variables.sync.syncthing.folders;
      options = {
        globalAnnounceEnabled = false;
        localAnnounceEnabled = true;
        relaysEnabled = false;
        natEnabled = false;
        urAccepted = -1;
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # KEYRING
  # ═══════════════════════════════════════════════════════════════════════════

  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" "ssh" "pkcs11" ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # NETWORK MANAGER APPLET
  # ═══════════════════════════════════════════════════════════════════════════

  services.network-manager-applet.enable = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # BLUEMAN
  # ═══════════════════════════════════════════════════════════════════════════

  services.blueman-applet.enable = variables.hardware.bluetooth;

  # ═══════════════════════════════════════════════════════════════════════════
  # PASYSTRAY (PulseAudio system tray)
  # ═══════════════════════════════════════════════════════════════════════════

  services.pasystray.enable = variables.hardware.audio;

  # ═══════════════════════════════════════════════════════════════════════════
  # FLAMESHOT (screenshot tool)
  # ═══════════════════════════════════════════════════════════════════════════

  services.flameshot = lib.mkIf variables.apps.flameshot {
    enable = true;
    settings = {
      General = {
        savePath = "${config.xdg.userDirs.pictures}/Screenshots";
        saveAsFileExtension = ".png";
        uiColor = "#7aa2f7";
        contrastUiColor = "#1a1b26";
        drawColor = "#ff0000";
        drawThickness = 3;
        disabledTrayIcon = false;
        showStartupLaunchMessage = false;
        showDesktopNotification = true;
        filenamePattern = "%F_%H-%M-%S";
      };
      Shortcuts = {
        TYPE_COPY = "Ctrl+C";
        TYPE_SAVE = "Ctrl+S";
        TYPE_UNDO = "Ctrl+Z";
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # DUNST (notification daemon - alternative to mako)
  # ═══════════════════════════════════════════════════════════════════════════

  services.dunst = lib.mkIf (variables.desktopEnvironment != "hyprland" && variables.desktopEnvironment != "plasma") {
    enable = true;
    
    settings = {
      global = {
        font = "${variables.theme.font.sans} 11";
        frame_width = 2;
        frame_color = if variables.theme.style == "dark" then "#cba6f7" else "#8839ef";
        separator_color = "frame";
        separator_height = 2;
        padding = 10;
        horizontal_padding = 10;
        text_icon_padding = 10;
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 64;
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        indicate_hidden = "yes";
        transparency = 5;
        corner_radius = 8;
        gap_size = 10;
        offset = "10x10";
        origin = "top-right";
        notification_limit = 5;
        idle_threshold = 120;
        history_length = 20;
        show_age_threshold = 60;
        markup = "full";
        plain_text = "no";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        dmenu = "${pkgs.wofi}/bin/wofi --dmenu";
        browser = variables.browser;
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        force_xinerama = false;
        follow = "mouse";
        sticky_history = "yes";
        enable_recursive_icon_lookup = true;
        icon_theme = "Papirus-Dark";
      };
      
      urgency_low = {
        background = if variables.theme.style == "dark" then "#1e1e2e" else "#eff1f5";
        foreground = if variables.theme.style == "dark" then "#cdd6f4" else "#4c4f69";
        timeout = 5;
      };
      
      urgency_normal = {
        background = if variables.theme.style == "dark" then "#1e1e2e" else "#eff1f5";
        foreground = if variables.theme.style == "dark" then "#cdd6f4" else "#4c4f69";
        timeout = 10;
      };
      
      urgency_critical = {
        background = if variables.theme.style == "dark" then "#1e1e2e" else "#eff1f5";
        foreground = if variables.theme.style == "dark" then "#f38ba8" else "#d20f39";
        frame_color = if variables.theme.style == "dark" then "#f38ba8" else "#d20f39";
        timeout = 0;
      };
      
      fullscreen_delay_everything = {
        fullscreen = "delay";
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # RANDOM BACKGROUND
  # ═══════════════════════════════════════════════════════════════════════════

  services.random-background = lib.mkIf variables.desktop.wallpaper.random {
    enable = true;
    imageDirectory = "${config.home.homeDirectory}/Pictures/Wallpapers";
    interval = variables.desktop.wallpaper.interval;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # HYPRPAPER (Hyprland wallpaper)
  # ═══════════════════════════════════════════════════════════════════════════

  services.hyprpaper = lib.mkIf (variables.desktopEnvironment == "hyprland" && !variables.desktop.wallpaper.random) {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
      preload = [ variables.desktop.wallpaper.path ];
      wallpaper = ",${variables.desktop.wallpaper.path}";
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # WAYBAR (Hyprland status bar)
  # ═══════════════════════════════════════════════════════════════════════════

  programs.waybar = lib.mkIf (variables.desktopEnvironment == "hyprland") {
    enable = true;
    systemd.enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        output = [ "eDP-1" "HDMI-A-1" "DP-1" ];
        
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ 
          "tray" 
          "idle_inhibitor" 
          "pulseaudio" 
          "network" 
          "cpu" 
          "memory" 
          "temperature" 
          "battery" 
          "custom/power" 
        ];
        
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "󰲠";
            "2" = "󰲢";
            "3" = "󰲤";
            "4" = "󰲦";
            "5" = "󰲨";
            "urgent" = "󰀨";
            "focused" = "󰪥";
            "default" = "󰧞";
          };
        };
        
        "hyprland/window" = {
          max-length = 50;
          separate-outputs = true;
        };
        
        tray = {
          spacing = 10;
        };
        
        clock = {
          timezone = variables.timezone;
          format = "{:%Y-%m-%d %H:%M:%S}";
          format-alt = "{:%H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
          calendar-weeks-pos = "right";
          today-format = "<span color='#f38ba8'><b><u>{}</u></b></span>";
          format-calendar = "<span color='#cdd6f4'><b>{}</b></span>";
          format-calendar-weeks = "<span color='#a6adc8'><b>W{}</b></span>";
          format-calendar-weekdays = "<span color='#f9e2af'><b>{}</b></span>";
        };
        
        cpu = {
          format = "{usage}% ";
          tooltip = true;
          interval = 1;
        };
        
        memory = {
          format = "{}% ";
          tooltip = true;
          interval = 1;
        };
        
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C ";
          format-critical = "{temperatureC}°C ";
          tooltip = true;
        };
        
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ " " " " " " " " " " ];
        };
        
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        
        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = "{icon}";
          format-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
        
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        
        "custom/power" = {
          format = " ";
          on-click = "wofi-power-menu";
          tooltip = false;
        };
      };
    };
    
    style = ''
      * {
        font-family: "${variables.theme.font.sans}";
        font-size: 13px;
        min-height: 0;
      }
      
      window#waybar {
        background-color: #1e1e2e;
        color: #cdd6f4;
        transition-property: background-color;
        transition-duration: .5s;
        border-radius: 0;
      }
      
      window#waybar.hidden {
        opacity: 0.2;
      }
      
      #workspaces button {
        padding: 0 10px;
        color: #cdd6f4;
        background-color: transparent;
        box-shadow: inset 0 -3px transparent;
        border: none;
        border-radius: 0;
      }
      
      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
        box-shadow: inset 0 -3px #cdd6f4;
      }
      
      #workspaces button.focused {
        background-color: #313244;
        box-shadow: inset 0 -3px #cba6f7;
      }
      
      #workspaces button.urgent {
        background-color: #f38ba8;
      }
      
      #clock,
      #battery,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #tray,
      #idle_inhibitor,
      #custom-power {
        padding: 0 10px;
        color: #cdd6f4;
      }
      
      #window,
      #workspaces {
        margin: 0 4px;
      }
      
      .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
      }
      
      .modules-right > widget:last-child > #custom-power {
        margin-right: 0;
      }
      
      #clock {
        background-color: #313244;
        border-radius: 8px;
      }
      
      #battery {
        background-color: #313244;
        border-radius: 8px;
      }
      
      #battery.charging, #battery.plugged {
        color: #a6e3a1;
        background-color: #313244;
      }
      
      @keyframes blink {
        to {
          background-color: #f38ba8;
          color: #1e1e2e;
        }
      }
      
      #battery.critical:not(.charging) {
        background-color: #f38ba8;
        color: #1e1e2e;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
      
      #cpu {
        background-color: #313244;
        border-radius: 8px;
      }
      
      #memory {
        background-color: #313244;
        border-radius: 8px;
      }
      
      #temperature {
        background-color: #313244;
        border-radius: 8px;
      }
      
      #temperature.critical {
        background-color: #f38ba8;
      }
      
      #network {
        background-color: #313244;
        border-radius: 8px;
      }
      
      #network.disconnected {
        background-color: #f38ba8;
      }
      
      #pulseaudio {
        background-color: #313244;
        border-radius: 8px;
      }
      
      #pulseaudio.muted {
        background-color: #313244;
        color: #6c7086;
      }
      
      #tray {
        background-color: #313244;
        border-radius: 8px;
      }
      
      #tray > .passive {
        -gtk-icon-effect: dim;
      }
      
      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #f38ba8;
      }
      
      #idle_inhibitor {
        background-color: #313244;
        border-radius: 8px;
      }
      
      #idle_inhibitor.activated {
        background-color: #cba6f7;
        color: #1e1e2e;
      }
      
      #custom-power {
        background-color: #f38ba8;
        color: #1e1e2e;
        border-radius: 8px;
        padding: 0 15px;
      }
    '';
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # WOFI (application launcher for Hyprland)
  # ═══════════════════════════════════════════════════════════════════════════

  programs.wofi = lib.mkIf (variables.desktopEnvironment == "hyprland") {
    enable = true;
    
    settings = {
      width = 600;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 32;
      gtk_dark = variables.theme.style == "dark";
    };
    
    style = ''
      * {
        font-family: "${variables.theme.font.sans}";
        font-size: 14px;
      }
      
      window {
        margin: 0px;
        border: 2px solid #cba6f7;
        border-radius: 12px;
        background-color: #1e1e2e;
        color: #cdd6f4;
      }
      
      #input {
        margin: 10px;
        padding: 10px;
        border: none;
        border-radius: 8px;
        background-color: #313244;
        color: #cdd6f4;
      }
      
      #input:focus {
        border: 2px solid #cba6f7;
      }
      
      #inner-box {
        margin: 10px;
        border: none;
        background-color: transparent;
      }
      
      #outer-box {
        margin: 10px;
        border: none;
        background-color: transparent;
      }
      
      #scroll {
        margin: 0px;
        border: none;
      }
      
      #text {
        margin: 5px;
        border: none;
        color: #cdd6f4;
      }
      
      #entry {
        padding: 8px;
        border-radius: 8px;
        background-color: transparent;
      }
      
      #entry:selected {
        background-color: #313244;
        border: 2px solid #cba6f7;
      }
      
      #entry:hover {
        background-color: #313244;
      }
    '';
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SWAYLOCK (screen locker for Hyprland)
  # ═══════════════════════════════════════════════════════════════════════════

  programs.swaylock = lib.mkIf (variables.desktopEnvironment == "hyprland") {
    enable = true;
    
    settings = {
      color = "1e1e2e";
      font = variables.theme.font.sans;
      font-size = 24;
      line-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      ring-color = "cba6f7";
      ring-clear-color = "f9e2af";
      ring-caps-lock-color = "f9e2af";
      ring-ver-color = "89b4fa";
      ring-wrong-color = "f38ba8";
      inside-color = "1e1e2e";
      inside-clear-color = "1e1e2e";
      inside-caps-lock-color = "1e1e2e";
      inside-ver-color = "1e1e2e";
      inside-wrong-color = "1e1e2e";
      separator-color = "00000000";
      text-color = "cdd6f4";
      text-clear-color = "f9e2af";
      text-caps-lock-color = "f9e2af";
      text-ver-color = "89b4fa";
      text-wrong-color = "f38ba8";
      bs-hl-color = "f9e2af";
      key-hl-color = "a6e3a1";
      caps-lock-bs-hl-color = "f9e2af";
      caps-lock-key-hl-color = "a6e3a1";
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "cdd6f4";
      daemonize = true;
      ignore-empty-password = false;
      show-failed-attempts = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 10;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # HYPRIDLE (idle management for Hyprland)
  # ═══════════════════════════════════════════════════════════════════════════

  services.hypridle = lib.mkIf (variables.desktopEnvironment == "hyprland") {
    enable = true;
    
    settings = {
      general = {
        lock_cmd = "pidof swaylock || swaylock";
        unlock_cmd = "";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
      };
      
      listener = [
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # HYPRLAND CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════

  wayland.windowManager.hyprland = lib.mkIf (variables.desktopEnvironment == "hyprland") {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    
    settings = {
      monitor = variables.hyprland.monitors;
      
      exec-once = [
        "waybar"
        "mako"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "hyprpaper"
        "hypridle"
        "nm-applet"
        "blueman-applet"
      ];
      
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "MOZ_ENABLE_WAYLAND,1"
      ];
      
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ee) rgba(b4befeee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };
      
      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };
      
      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0,0.35,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };
      
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      master = {
        new_status = "master";
      };
      
      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };
      
      input = {
        kb_layout = variables.keyboard.layout;
        kb_variant = variables.keyboard.variant;
        kb_model = "";
        kb_options = variables.keyboard.options;
        kb_rules = "";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          clickfinger_behavior = true;
        };
      };
      
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };
      
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };
      
      "$mainMod" = "SUPER";
      
      bind = [
        # Basic
        "$mainMod, Q, exec, ${variables.terminal}"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, nautilus"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, wofi --show drun"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, L, exec, swaylock"
        "$mainMod, F, fullscreen,"
        
        # Focus
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        
        # Move windows
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        
        # Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        
        # Move to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        
        # Special workspace
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        
        # Scroll through workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        
        # Screenshots
        ", Print, exec, grimblast copy area"
        "SHIFT, Print, exec, grimblast save area"
        "CTRL, Print, exec, grimblast copy active"
        "CTRL SHIFT, Print, exec, grimblast save active"
        
        # Clipboard history
        "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"
        
        # Lock screen
        "CTRL ALT, L, exec, swaylock"
        
        # Application shortcuts
        "$mainMod, B, exec, ${variables.browser}"
        "$mainMod, T, exec, ${variables.terminal}"
        "$mainMod, N, exec, nautilus"
        "$mainMod, M, exec, spotify"
      ];
      
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
      
      bindl = [
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPrev, exec, playerctl previous"
      ];
      
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        "float,class:^(pavucontrol|blueman-manager|nm-connection-editor)$"
        "size 800 600,class:^(pavucontrol|blueman-manager|nm-connection-editor)$"
        "center,class:^(pavucontrol|blueman-manager|nm-connection-editor)$"
      ];
      
      layerrule = [
        "blur, waybar"
        "ignorezero, waybar"
        "blur, notifications"
        "ignorezero, notifications"
      ];
    };
  };
}
