# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  profiles/base.nix - Base System Profile                                  ║
# ║                                                                             ║
# ║  This is the foundation that ALL systems share. It imports:                ║
# ║  - User accounts                                                            ║
# ║  - Boot configuration                                                       ║
# ║  - Core system settings                                                     ║
# ║  - Essential packages                                                       ║
# ║  - Hardware drivers                                                         ║
# ║                                                                             ║
# ║  Other profiles (laptop, desktop) build on top of this.                    ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Core system components (everyone needs these)
    ../home/core/users.nix # User account setup
    ../system/core/boot.nix # Boot loader configuration
    ../system/core/settings.nix # Nix settings & state version
    ../system/core/locale.nix # Language, timezone, keyboard
    ../system/core/security.nix # Security policies (sudo, etc.)

    # System software
    ../system/software/packages.nix # CLI tools & utilities
    ../system/software/programs.nix # System-wide programs
    ../system/software/services.nix # Background services

    # Hardware support
    ../system/hardware/networking.nix # WiFi, firewall, DNS
    ../system/hardware/bluetooth.nix # Bluetooth support
    ../system/hardware/virtualization.nix # VMs & containers

    # Desktop environment
    ../home/desktop/desktop.nix # Plasma/COSMIC desktop
  ];
}
