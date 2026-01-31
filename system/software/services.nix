# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  system/software/services.nix - Background Services                      ║
# ║                                                                             ║
# ║  System services that run in the background.                               ║
# ║  These provide features like network discovery, printing, updates, etc.   ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{ variables, ... }:
{
  services = {

    # ─────────────────────────────────────────────────────────────────────────
    # 🔍 AVAHI
    # Network service discovery (find printers, NAS, etc. on local network)
    # ─────────────────────────────────────────────────────────────────────────

    avahi = {
      enable = true;
      nssmdns4 = true; # .local domain resolution
      openFirewall = true;
    };

    # ─────────────────────────────────────────────────────────────────────────
    # 📦 FLATPAK
    # Alternative app store (for apps not in Nix)
    # Install apps with: flatpak install flathub <app-name>
    # ─────────────────────────────────────────────────────────────────────────

    flatpak = {
      enable = true;
    };

    # ─────────────────────────────────────────────────────────────────────────
    # 🔄 FWUPD
    # Firmware updates for hardware (BIOS, SSDs, etc.)
    # Run: fwupdmgr refresh && fwupdmgr update
    # ─────────────────────────────────────────────────────────────────────────

    fwupd = {
      enable = true;
    };

    # ─────────────────────────────────────────────────────────────────────────
    # 🖨️ PRINTING (CUPS)
    # Printer support - controlled from variables.nix: hardware.printing
    # ─────────────────────────────────────────────────────────────────────────

    printing = {
      enable = variables.hardware.printing;
    };

    # ─────────────────────────────────────────────────────────────────────────
    # 🔐 SSH SERVER
    # Allows remote access to this computer (disabled by default for security)
    # ─────────────────────────────────────────────────────────────────────────

    openssh = {
      enable = false; # Set to true to enable remote access

      settings = {
        PasswordAuthentication = false; # Only allow key-based login
        PermitRootLogin = "no"; # Don't allow root login
      };
    };
  };
}
