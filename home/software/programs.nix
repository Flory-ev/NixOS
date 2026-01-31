# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  home/software/programs.nix - User Program Configuration                  ║
# ║                                                                             ║
# ║  Programs that need configuration (not just installation).                ║
# ║  These are managed by Home Manager and create dotfiles automatically.     ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  lib,
  pkgs,
  variables,
  ...
}:
{
  programs = {

    # ─────────────────────────────────────────────────────────────────────────
    # 📁 DIRENV - Auto-load project environments
    # Automatically activates when you cd into a project directory
    # ─────────────────────────────────────────────────────────────────────────

    direnv = {
      enable = true;
      nix-direnv.enable = true; # Better Nix integration
    };

    # ─────────────────────────────────────────────────────────────────────────
    # 🔍 FZF - Fuzzy finder
    # Press Ctrl+R for command history, Ctrl+T for file search
    # ─────────────────────────────────────────────────────────────────────────

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # ─────────────────────────────────────────────────────────────────────────
    # 📝 GIT - Version control
    # Settings from variables.nix
    # ─────────────────────────────────────────────────────────────────────────

    git = {
      enable = true;

      # GPG signing (if enabled in variables.nix)
      signing = lib.mkIf variables.git.gpgSign {
        key = variables.git.gpgKey;
        signByDefault = true;
      };

      settings = {
        # User identity (from variables.nix)
        user = {
          name = variables.fullName;
          email = variables.email;
        };

        # Default branch name for new repositories
        init.defaultBranch = variables.git.defaultBranch;

        # Useful defaults
        pull.rebase = false; # Merge by default on pull
        push.autoSetupRemote = true; # Auto-set upstream on first push
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # 🏠 NH - NixOS helper tool
    # Use 'nh os switch' instead of 'sudo nixos-rebuild switch'
    # ─────────────────────────────────────────────────────────────────────────

    nh = {
      enable = true;
      flake = variables.flakePath; # Path to your config

      # Automatic cleanup of old generations
      clean = {
        enable = true;
        extraArgs = "--keep-since ${variables.gc.olderThan} --keep ${toString variables.gc.keep}";
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # ⭐ STARSHIP - Beautiful shell prompt
    # Shows git status, directory, and more
    # ─────────────────────────────────────────────────────────────────────────

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    # ─────────────────────────────────────────────────────────────────────────
    # 📂 ZOXIDE - Smarter cd command
    # Type 'cd <partial-path>' to jump to frequently used directories
    # ─────────────────────────────────────────────────────────────────────────

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ]; # Replace cd with zoxide
    };

    # ─────────────────────────────────────────────────────────────────────────
    # 🐚 ZSH - Shell configuration
    # Your command-line shell with auto-suggestions and syntax highlighting
    # ─────────────────────────────────────────────────────────────────────────

    zsh = {
      enable = true;
      enableCompletion = true; # Tab completion
      autosuggestion.enable = true; # Fish-like suggestions
      syntaxHighlighting.enable = true; # Colorize commands

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git" # Git aliases (gst, ga, gc, etc.)
          "sudo" # Press Esc twice to add sudo
        ];
      };
    };
  };
}
