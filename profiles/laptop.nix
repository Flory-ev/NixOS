# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  profiles/laptop.nix - Laptop-Specific Profile                             ║
# ║                                                                             ║
# ║  Extends the base profile with laptop-specific features:                   ║
# ║  - Power management (battery optimization)                                  ║
# ║  - Touchpad configuration                                                   ║
# ║  - Brightness control                                                       ║
# ║  - Memory management                                                        ║
# ║  - Audio & graphics support                                                 ║
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
  # KERNEL TWEAKS
  # ─────────────────────────────────────────────────────────────────────────────

  # Fix for NVMe SSDs that have issues with power saving
  boot.kernelParams = [ "nvme_core.default_ps_max_latency_us=0" ];

  # ─────────────────────────────────────────────────────────────────────────────
  # SCREEN BRIGHTNESS
  # ─────────────────────────────────────────────────────────────────────────────

  programs.light.enable = true; # Backlight control for laptops

  # ─────────────────────────────────────────────────────────────────────────────
  # MEMORY MANAGEMENT
  # ─────────────────────────────────────────────────────────────────────────────

  # Compressed RAM swap (better than disk swap for laptops)
  zramSwap = {
    enable = true;
    memoryPercent = 50; # Use up to 50% of RAM for zram
  };

  # ─────────────────────────────────────────────────────────────────────────────
  # SERVICES
  # ─────────────────────────────────────────────────────────────────────────────

  services = {
    # TLP - Advanced power management for Linux laptops
    # Automatically adjusts settings when on AC vs battery
    tlp = {
      enable = true;
      settings = {
        # CPU Performance
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_BOOST_ON_AC = 1; # Turbo boost on AC
        CPU_BOOST_ON_BAT = 0; # Disable turbo on battery

        # Battery health - don't charge to 100%
        START_CHARGE_THRESH_BAT0 = 20; # Start charging below 20%
        STOP_CHARGE_THRESH_BAT0 = 80; # Stop charging at 80%

        # USB power saving
        USB_AUTOSUSPEND = 1;
        USB_EXCLUDE_AUDIO = 1; # Don't suspend audio devices

        # Disk power management
        DISK_DEVICES = "nvme0n1 sda";
        DISK_APM_LEVEL_ON_AC = "254 254";
        DISK_APM_LEVEL_ON_BAT = "128 128";

        # WiFi power saving
        WIFI_PWR_ON_AC = "off"; # Full power on AC
        WIFI_PWR_ON_BAT = "on"; # Save power on battery

        # Runtime power management
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";
      };
    };

    # Touchpad configuration
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true; # Scroll like a phone
        tapping = true; # Tap to click
        disableWhileTyping = false;
        accelSpeed = "0.5"; # Pointer speed
        clickMethod = "clickfinger"; # Two-finger = right-click
        tappingDragLock = false;
        scrollMethod = "twofinger";
      };
    };

    # Kill processes if RAM gets critically low (prevents freeze)
    earlyoom = {
      enable = true;
      freeMemThreshold = 5; # Act when <5% RAM free
    };

    # Fingerprint reader support
    fprintd.enable = true;

    # SSD optimization
    fstrim.enable = true;

    # USB drive auto-mount
    gvfs.enable = true;

    # Use TLP instead of power-profiles-daemon
    power-profiles-daemon.enable = false;

    # Thermal management (prevents overheating)
    thermald.enable = true;

    # USB storage mounting
    udisks2.enable = true;
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
