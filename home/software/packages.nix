# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  home/software/packages.nix - User Applications                           ║
# ║                                                                             ║
# ║  GUI applications installed for your user account.                         ║
# ║  Add or remove apps here - they'll be available after rebuild.            ║
# ║                                                                             ║
# ║  Find packages at: https://search.nixos.org/packages                       ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{ pkgs, variables, ... }:
{
  home.packages = with pkgs; [

    # ─────────────────────────────────────────────────────────────────────────
    # 🌐 INTERNET & COMMUNICATION
    # ─────────────────────────────────────────────────────────────────────────

    discord # Voice & text chat
    telegram-desktop # Messaging app
    thunderbird # Email client
    qbittorrent # Torrent client
    tor-browser # Private browsing

    # ─────────────────────────────────────────────────────────────────────────
    # 🔐 SECURITY
    # ─────────────────────────────────────────────────────────────────────────

    bitwarden-desktop # Password manager

    # ─────────────────────────────────────────────────────────────────────────
    # 🎮 GAMING
    # ─────────────────────────────────────────────────────────────────────────

    lutris # Game launcher (GOG, Epic, etc.)

    # ─────────────────────────────────────────────────────────────────────────
    # 🎵 MEDIA
    # ─────────────────────────────────────────────────────────────────────────

    spotify # Music streaming
    vlc # Video player
    reaper # Digital audio workstation

    # ─────────────────────────────────────────────────────────────────────────
    # 💻 DEVELOPMENT & TOOLS
    # ─────────────────────────────────────────────────────────────────────────

    # Terminal - from variables.nix
    (
      if variables.terminal == "kitty" then
        kitty
      else if variables.terminal == "alacritty" then
        alacritty
      else if variables.terminal == "wezterm" then
        wezterm
      else
        kitty
    )

    # Code editor - from variables.nix
    (
      if variables.editor == "vscodium" then
        vscodium
      else if variables.editor == "vscode" then
        vscode
      else if variables.editor == "neovim" then
        neovim
      else if variables.editor == "helix" then
        helix
      else
        antigravity
    )

    # Browser - from variables.nix (additional to Firefox)
    (
      if variables.browser == "chromium" then
        chromium
      else if variables.browser == "brave" then
        brave
      else if variables.browser == "vivaldi" then
        vivaldi
      else
        chromium
    )

    # ─────────────────────────────────────────────────────────────────────────
    # 📁 UTILITIES
    # ─────────────────────────────────────────────────────────────────────────

    ncdu # Disk usage analyzer
    tree # Directory tree view
  ];
}
