# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  system/core/boot.nix - Boot Loader Configuration                        ║
# ║                                                                             ║
# ║  Controls how your system boots:                                           ║
# ║  - Boot loader (systemd-boot)                                              ║
# ║  - Kernel selection                                                         ║
# ║  - Boot splash (Plymouth)                                                   ║
# ║  - Temporary files                                                          ║
# ║                                                                             ║
# ║  Settings controlled from variables.nix: boot.silent, boot.plymouth,      ║
# ║  boot.configLimit                                                           ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  lib,
  pkgs,
  variables,
  ...
}:
{
  boot = {
    # ─────────────────────────────────────────────────────────────────────────
    # KERNEL
    # ─────────────────────────────────────────────────────────────────────────

    # Use the latest stable kernel
    kernelPackages = pkgs.linuxPackages_latest;

    # Kernel parameters (from variables.nix)
    # "quiet" and "splash" hide boot messages for a cleaner startup
    kernelParams = lib.optionals variables.boot.silent [
      "quiet"
      "splash"
    ];

    # ─────────────────────────────────────────────────────────────────────────
    # BOOT LOADER
    # ─────────────────────────────────────────────────────────────────────────

    loader = {
      # EFI settings
      efi = {
        canTouchEfiVariables = true; # Allow modifying EFI variables
        efiSysMountPoint = "/boot"; # Where EFI partition is mounted
      };

      # systemd-boot (simple, fast UEFI boot loader)
      systemd-boot = {
        enable = true;
        editor = false; # Disable boot entry editing (security)
        configurationLimit = variables.boot.configLimit; # Max entries to keep
      };
    };

    # ─────────────────────────────────────────────────────────────────────────
    # TEMPORARY FILES
    # ─────────────────────────────────────────────────────────────────────────

    # Use RAM for /tmp (faster, clears on reboot)
    tmp = {
      useTmpfs = true;
      tmpfsSize = "50%"; # Max 50% of RAM for /tmp
    };

    # ─────────────────────────────────────────────────────────────────────────
    # BOOT SPLASH
    # ─────────────────────────────────────────────────────────────────────────

    # Plymouth shows a nice animation during boot (from variables.nix)
    plymouth.enable = variables.boot.plymouth;
  };

  # ─────────────────────────────────────────────────────────────────────────────
  # FIRMWARE
  # ─────────────────────────────────────────────────────────────────────────────

  # Enable proprietary firmware (needed for WiFi, GPU, etc.)
  hardware.enableRedistributableFirmware = true;
}
