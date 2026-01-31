# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  system/software/packages.nix - System CLI Tools                         ║
# ║                                                                             ║
# ║  Command-line utilities available system-wide.                             ║
# ║  These are tools you use in the terminal.                                  ║
# ║                                                                             ║
# ║  Find more at: https://search.nixos.org/packages                           ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    # ─────────────────────────────────────────────────────────────────────────
    # 📁 FILE MANAGEMENT
    # ─────────────────────────────────────────────────────────────────────────

    eza # Modern 'ls' replacement
    fd # Modern 'find' replacement
    ripgrep # Fast grep (search in files)
    unzip # Extract .zip files

    # ─────────────────────────────────────────────────────────────────────────
    # 🔧 SYSTEM UTILITIES
    # ─────────────────────────────────────────────────────────────────────────

    bat # 'cat' with syntax highlighting
    btop # Beautiful system monitor
    fastfetch # System info display
    tldr # Simplified man pages
    gparted # Partition manager (GUI)

    # ─────────────────────────────────────────────────────────────────────────
    # 🌐 NETWORKING
    # ─────────────────────────────────────────────────────────────────────────

    curl # Download files / API calls
    wget # Download files

    # ─────────────────────────────────────────────────────────────────────────
    # 💻 DEVELOPMENT
    # ─────────────────────────────────────────────────────────────────────────

    direnv # Auto-load project environments
    fzf # Fuzzy finder
    gh # GitHub CLI
    lazygit # Git TUI
    vim # Text editor
    nixfmt-rfc-style # Nix code formatter

    # ─────────────────────────────────────────────────────────────────────────
    # 🐚 SHELL ENHANCEMENTS
    # ─────────────────────────────────────────────────────────────────────────

    zoxide # Smarter cd command
  ];
}
