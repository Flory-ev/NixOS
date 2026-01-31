# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  home/core/users.nix - User Account Configuration                         ║
# ║                                                                             ║
# ║  Creates and configures user accounts on the system.                       ║
# ║  Settings here affect login, permissions, and default shell.              ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{ pkgs, variables, ... }:
{
  # ─────────────────────────────────────────────────────────────────────────────
  # CREATE USER ACCOUNT
  # ─────────────────────────────────────────────────────────────────────────────

  users.users.${variables.username} = {
    isNormalUser = true; # Regular user (not system account)
    isSystemUser = false;

    # Default shell - controlled from variables.nix
    shell =
      if variables.defaultShell == "zsh" then
        pkgs.zsh
      else if variables.defaultShell == "fish" then
        pkgs.fish
      else
        pkgs.bash;

    # User's primary group (same as username)
    group = variables.username;

    # Additional group memberships
    extraGroups = [
      "wheel" # Allows using sudo
      "networkmanager" # Allows managing WiFi
      "video" # Screen brightness control
      "audio" # Audio device access
      "libvirtd" # VM management (if enabled)
    ];

    # User description (full name)
    description = variables.fullName;
  };

  # Create the user's primary group
  users.groups.${variables.username} = { };
}
