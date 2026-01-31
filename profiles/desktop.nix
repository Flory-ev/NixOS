# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  profiles/desktop.nix - Desktop PC Profile                                ║
# ║                                                                             ║
# ║  Use this profile for desktop computers (not laptops).                    ║
# ║  It has audio/graphics but not power management or touchpad settings.    ║
# ║                                                                             ║
# ║  To use: In hosts/yourhost/default.nix, import ../../profiles/desktop.nix ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./base.nix # Everything from base profile
    ../system/hardware/audio.nix # PipeWire audio
    ../system/hardware/graphics.nix # GPU/OpenGL support
  ];

  # ─────────────────────────────────────────────────────────────────────────────
  # DESKTOP SERVICES
  # ─────────────────────────────────────────────────────────────────────────────

  services = {
    # USB storage auto-mount
    udisks2.enable = true;

    # Virtual filesystem (for trash, network mounts, etc.)
    gvfs.enable = true;

    # SSD optimization (if you have SSDs)
    fstrim.enable = true;
  };

  # ─────────────────────────────────────────────────────────────────────────────
  # FONTS
  # ─────────────────────────────────────────────────────────────────────────────

  fonts.packages = with pkgs; [
    noto-fonts # Google's font family
    noto-fonts-cjk-sans # Chinese/Japanese/Korean
    noto-fonts-color-emoji # Emoji support
    liberation_ttf # Free replacements for Microsoft fonts
    fira-code # Coding font with ligatures
    fira-code-symbols
    font-awesome # Icon font
    jetbrains-mono # Excellent coding font
  ];
}
