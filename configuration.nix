{
  config,
  inputs ? { },
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  # ============================================================================
  # Boot Configuration
  # ============================================================================

  boot = {
    consoleLogLevel = 3;
    
    initrd = {
      systemd.enable = true;
      verbose = true;
    };

    # Security hardening
    kernel.sysctl = {
      "kernel.dmesg_restrict" = true;
      "kernel.kptr_restrict" = 2;
      "kernel.unprivileged_bpf_disabled" = 1;
    };

    kernelModules = [ "btusb" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "mitigations=auto" ];

    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 5;
      
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "max";
        configurationLimit = 10;
      };
    };

    plymouth = {
      enable = true;
      theme = "breeze";
    };

    tmp.cleanOnBoot = true;
  };

  # ============================================================================
  # Hardware Configuration
  # ============================================================================

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };

    enableRedistributableFirmware = true;
    firmware = [ pkgs.linux-firmware ];
    
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    ksm.enable = true;
  };

  # ============================================================================
  # Networking
  # ============================================================================

  networking = {
    hostName = "vortex";
    wireguard.enable = false;

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 7777 ];
      allowedUDPPorts = [ 7777 ];
      logRefusedConnections = false;
    };

    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = false;
      };
    };
  };

  # ============================================================================
  # Localization
  # ============================================================================

  time.timeZone = "Europe/Copenhagen";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  console = {
    font = "Lat2-Terminus16";
    packages = [ pkgs.terminus_font ];
  };

  # ============================================================================
  # Fonts
  # ============================================================================

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      fira-code
      font-awesome
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };

  # ============================================================================
  # Desktop Environment & Display
  # ============================================================================

  services = {
    desktopManager.plasma6.enable = true;
    
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        disableWhileTyping = false;
      };
    };

    # Audio
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
      
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    # System Services
    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
    };

    flatpak.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    logrotate.enable = true;
    smartd.enable = true;
    thermald.enable = true;

    locate = {
      enable = true;
      package = pkgs.plocate;
      interval = "daily";
    };

    # DNS Resolution
    resolved = {
      enable = true;
      settings.Resolve = {
        DNSSEC = "true";
        DNSOverTLS = "opportunistic";
        FallbackDNS = "1.1.1.1 8.8.8.8";
      };
    };

    # Power Management
    power-profiles-daemon.enable = lib.mkForce false;
    
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };

  # ============================================================================
  # Programs & Applications
  # ============================================================================

  programs = {
    # Desktop Applications
    firefox.enable = true;
    kdeconnect.enable = true;

    # Gaming
    gamemode.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    # Development Tools
    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        user.name = "Your Name";
        user.email = "your.email@example.com";
      };
    };

    # Shell
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };

    # Virtualization & Container Support
    virt-manager.enable = true;
    
    appimage = {
      enable = true;
      binfmt = true;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [ stdenv.cc.cc zlib ];
    };
  };

  # ============================================================================
  # System Packages
  # ============================================================================

  environment.systemPackages = with pkgs; [
    bat
    curl
    eza
    fd
    fzf
    nh
    wget
    zoxide
  ];

  # ============================================================================
  # Virtualization
  # ============================================================================

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      storageDriver = "overlay2";
    };

    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
    };

    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # ============================================================================
  # Memory Management
  # ============================================================================

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # ============================================================================
  # Nix Configuration
  # ============================================================================

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ "https://cache.nixos.org/" ];
      trusted-public-keys = [ 
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" 
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  # ============================================================================
  # User Configuration
  # ============================================================================

  users.users.f = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ 
      "docker"
      "libvirtd"
      "networkmanager"
      "wheel"
    ];
  };

  security.sudo.wheelNeedsPassword = true;

  # ============================================================================
  # System Version
  # ============================================================================

  system.stateVersion = "25.05";
}
