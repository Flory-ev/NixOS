# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  system/core/security.nix - Security Settings                             ║
# ║                                                                             ║
# ║  System security configuration:                                             ║
# ║  - Sudo settings                                                            ║
# ║  - Polkit (privilege escalation)                                           ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{ ... }:
{
  security = {

    # ─────────────────────────────────────────────────────────────────────────
    # POLKIT
    # Manages fine-grained access control (used by GUI apps for admin actions)
    # ─────────────────────────────────────────────────────────────────────────

    polkit.enable = true;

    # ─────────────────────────────────────────────────────────────────────────
    # SUDO
    # Controls who can run commands as root
    # ─────────────────────────────────────────────────────────────────────────

    sudo = {
      enable = true;
      wheelNeedsPassword = true; # Require password for sudo
      execWheelOnly = true; # Only wheel group can use sudo
    };
  };
}
