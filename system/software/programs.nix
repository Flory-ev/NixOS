# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  system/software/programs.nix - System-Wide Programs                     ║
# ║                                                                             ║
# ║  Programs enabled at the system level (available to all users).           ║
# ║  These often require special permissions or system integration.            ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{ pkgs, variables, ... }:
{
  programs = {

    # ─────────────────────────────────────────────────────────────────────────
    # 📦 APPIMAGE SUPPORT
    # Run .AppImage files directly (like Windows .exe)
    # ─────────────────────────────────────────────────────────────────────────

    appimage = {
      enable = true;
      binfmt = true; # Register as executable format
    };

    # ─────────────────────────────────────────────────────────────────────────
    # 🌐 FIREFOX
    # Mozilla Firefox browser (always available as backup)
    # ─────────────────────────────────────────────────────────────────────────

    firefox = {
      enable = true;
    };

    # ─────────────────────────────────────────────────────────────────────────
    # 🎮 GAMING
    # ─────────────────────────────────────────────────────────────────────────

    # GameMode - optimizes system for gaming when games are running
    gamemode = {
      enable = true;
    };

    # Steam - PC gaming platform
    steam = {
      enable = true;

      # Open firewall ports for Steam features
      remotePlay.openFirewall = true; # Stream games to other devices
      dedicatedServer.openFirewall = true; # Host game servers
      localNetworkGameTransfers.openFirewall = true; # LAN game transfers

      # Proton-GE - community build with extra game fixes
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    # ─────────────────────────────────────────────────────────────────────────
    # 🐚 ZSH
    # Z Shell - must be enabled system-wide to use as login shell
    # Configured from variables.nix: defaultShell
    # ─────────────────────────────────────────────────────────────────────────

    zsh = {
      enable = variables.defaultShell == "zsh";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # 🐟 FISH
    # Fish Shell - friendly interactive shell
    # Configured from variables.nix: defaultShell
    # ─────────────────────────────────────────────────────────────────────────

    fish = {
      enable = variables.defaultShell == "fish";
    };
  };
}
