# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                        NixOS System Configuration                          ║
# ║                                                                             ║
# ║  This file contains ALL system-level settings. Everything is controlled    ║
# ║  by variables.nix - just change values there and rebuild.                  ║
# ║                                                                             ║
# ║  Rebuild with: nh os switch                                                ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  config,
  lib,
  pkgs,
  variables,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  # ═══════════════════════════════════════════════════════════════════════════
  # SYSTEM IDENTITY
  # ═══════════════════════════════════════════════════════════════════════════

  networking.hostName = variables.hostname;
  system.stateVersion = variables.stateVersion;

  # ═══════════════════════════════════════════════════════════════════════════
  # BOOT CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════

  boot = {
    # Boot loader
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = variables.boot.configLimit;
      efi.canTouchEfiVariables = true;
    };

    # Kernel
    kernelPackages = pkgs.linuxPackages_latest;
    
    # Silent boot
    consoleLogLevel = if variables.boot.silent then 0 else 3;
    kernelParams = lib.optionals variables.boot.silent [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    # Plymouth boot splash
    plymouth.enable = variables.boot.plymouth;

    # Clean /tmp on boot
    tmp.cleanOnBoot = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # LOCALIZATION
  # ═══════════════════════════════════════════════════════════════════════════

  time.timeZone = variables.timezone;

  i18n = {
    defaultLocale = variables.locale;
    extraLocaleSettings = {
      LC_ADDRESS = variables.locale;
      LC_IDENTIFICATION = variables.locale;
      LC_MEASUREMENT = variables.locale;
      LC_MONETARY = variables.locale;
      LC_NAME = variables.locale;
      LC_NUMERIC = variables.locale;
      LC_PAPER = variables.locale;
      LC_TELEPHONE = variables.locale;
      LC_TIME = variables.locale;
    };
  };

  services.xserver.xkb = {
    layout = variables.keyboard.layout;
    variant = variables.keyboard.variant;
    options = variables.keyboard.options;
  };

  console.keyMap = lib.mkIf (variables.keyboard.variant == "dvorak") "dvorak";

  # ═══════════════════════════════════════════════════════════════════════════
  # NETWORKING
  # ═══════════════════════════════════════════════════════════════════════════

  networking = {
    networkmanager.enable = true;
    
    # DNS
    nameservers = [ variables.dns.primary variables.dns.secondary ];
    
    # Firewall
    firewall = {
      enable = variables.firewall.enable;
      allowedTCPPorts = variables.firewall.openPorts;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # HARDWARE
  # ═══════════════════════════════════════════════════════════════════════════

  # Audio (PipeWire)
  services.pipewire = lib.mkIf variables.hardware.audio {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = lib.mkIf variables.hardware.bluetooth {
    enable = true;
    powerOnBoot = true;
    settings.General.Enable = "Source,Sink,Media,Socket";
  };

  # Graphics
  hardware.graphics = lib.mkIf variables.hardware.opengl {
    enable = true;
    enable32Bit = true;
  };

  # Printing
  services.printing.enable = variables.hardware.printing;

  # Virtualization
  virtualisation.libvirtd = lib.mkIf variables.hardware.virtualization {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };

  programs.virt-manager.enable = variables.hardware.virtualization;

  # ═══════════════════════════════════════════════════════════════════════════
  # LAPTOP-SPECIFIC (auto-detected)
  # ═══════════════════════════════════════════════════════════════════════════

  # Power management
  services.tlp = lib.mkIf (builtins.pathExists /sys/class/power_supply/BAT0) {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # Touchpad
  services.libinput = lib.mkIf (builtins.pathExists /sys/class/power_supply/BAT0) {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
    };
  };

  # Better memory management for laptops
  services.earlyoom = lib.mkIf (builtins.pathExists /sys/class/power_supply/BAT0) {
    enable = true;
    freeMemThreshold = 5;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # DESKTOP ENVIRONMENT
  # ═══════════════════════════════════════════════════════════════════════════

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;

  # KDE Plasma
  services.desktopManager.plasma6.enable = variables.enablePlasma;

  # COSMIC (requires unstable channel)
  services.desktopManager.cosmic.enable = variables.enableCosmic;

  # Default session
  services.displayManager.defaultSession = variables.defaultSession;

  # ═══════════════════════════════════════════════════════════════════════════
  # USER ACCOUNTS
  # ═══════════════════════════════════════════════════════════════════════════

  users.users.${variables.username} = {
    isNormalUser = true;
    description = variables.fullName;
    extraGroups = [ 
      "wheel" 
      "networkmanager" 
    ] ++ lib.optionals variables.hardware.virtualization [ "libvirtd" ];
    shell = pkgs.${variables.defaultShell};
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SECURITY
  # ═══════════════════════════════════════════════════════════════════════════

  security = {
    polkit.enable = true;
    sudo.wheelNeedsPassword = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # NIX SETTINGS
  # ═══════════════════════════════════════════════════════════════════════════

  nix = {
    # Modern Nix features
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
      auto-optimise-store = true;
    };

    # Garbage collection
    gc = lib.mkIf variables.gc.automatic {
      automatic = true;
      dates = variables.gc.frequency;
      options = "--delete-older-than ${variables.gc.olderThan}";
    };

    # Keep minimum generations
    settings.keep-outputs = true;
    settings.keep-derivations = true;
  };

  nixpkgs.config.allowUnfree = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # SYSTEM PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════

  environment.systemPackages = with pkgs; [
    # Essential CLI tools
    wget
    curl
    git
    vim
    
    # Modern CLI replacements
    eza      # Better ls
    fd       # Better find
    ripgrep  # Better grep
    bat      # Better cat
    btop     # System monitor
    fastfetch # System info
    
    # Archives
    zip
    unzip
    p7zip
    
    # System tools
    pciutils
    usbutils
    lshw
    
    # NH (Nix Helper)
    nh
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # SYSTEM PROGRAMS
  # ═══════════════════════════════════════════════════════════════════════════

  programs = {
    # AppImage support
    appimage = {
      enable = true;
      binfmt = true;
    };

    # Flatpak
    flatpak.enable = true;

    # Git
    git = {
      enable = true;
      config = {
        init.defaultBranch = variables.git.defaultBranch;
        user.name = variables.fullName;
        user.email = variables.email;
        commit.gpgsign = variables.git.gpgSign;
        user.signingkey = lib.mkIf variables.git.gpgSign variables.git.gpgKey;
      };
    };

    # Fish shell
    fish.enable = (variables.defaultShell == "fish");
    
    # Zsh
    zsh.enable = (variables.defaultShell == "zsh");
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SERVICES
  # ═══════════════════════════════════════════════════════════════════════════

  # Flatpak repo
  services.flatpak.packages = [ ];

  # Update DB for locate command
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    localuser = null;
  };

  # Fwupd (firmware updates)
  services.fwupd.enable = true;

  # Trim SSD weekly
  services.fstrim.enable = true;
}
