# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  home/core/home.nix - Home Manager Entry Point                            ║
# ║                                                                             ║
# ║  This manages user-specific configuration (your dotfiles, apps, etc.)     ║
# ║  It works alongside NixOS to configure things in your home directory.     ║
# ║                                                                             ║
# ║  Think of NixOS as "system settings" and Home Manager as "user settings"  ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  config,
  pkgs,
  variables,
  ...
}:
{
  imports = [
    ../software/packages.nix # User applications (GUI apps)
    ../software/programs.nix # Configured programs (shell, git, etc.)
  ];

  # ─────────────────────────────────────────────────────────────────────────────
  # HOME MANAGER STATE VERSION
  # Don't change this after initial setup!
  # ─────────────────────────────────────────────────────────────────────────────

  home.stateVersion = variables.stateVersion;
}
