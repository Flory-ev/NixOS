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
  inputs ? {},
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
      systemd-boot = {
        enable = true;
        configurationLimit = variables.boot.configLimit;
        editor = false;  # Disable editor for security
        consoleMode = "max";  # Use max resolution
      };
      efi.canTouchEfiVariables = true;
      timeout = variables.boot.timeout;
    };

    # Kernel
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = lib.optionals variables.hardware.bluetooth [ "btusb" ];
    
    # Kernel hardening options
    kernel.sysctl = lib.mkIf variables.security.hardening {
      "kernel.dmesg_restrict" = true;
      "kernel.kptr_restrict" = 2;
      "kernel.printk" = "3 3 3 3";
      "kernel.unprivileged_bpf_disabled" = 1;
      "net.core.bpf_jit_harden" = 2;
    };
    
    # Silent boot
    consoleLogLevel = if variables.boot.silent then 0 else 3;
    kernelParams = lib.optionals variables.boot.silent [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ] ++ lib.optionals variables.boot.mitigations [ "mitigations=auto" ];

    # Plymouth boot splash
    plymouth = {
      enable = variables.boot.plymouth;
      theme = variables.boot.plymouthTheme;
    };

    # Clean /tmp on boot
    tmp.cleanOnBoot = true;
    
    # Initrd configuration
    initrd = {
      systemd.enable = true;
      verbose = !variables.boot.silent;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # LOCALIZATION
  # ═══════════════════════════════════════════════════════════════════════════

  time.timeZone = variables.timezone;
  time.hardwareClockInLocalTime = lib.mkIf variables.windowsDualBoot true;

  i18n = {
    defaultLocale = variables.locale;
    supportedLocales = variables.supportedLocales;
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

  console = {
    keyMap = lib.mkIf (variables.keyboard.variant == "dvorak") "dvorak";
    font = variables.console.font;
    packages = [ pkgs.${variables.console.fontPackage} ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # NETWORKING
  # ═══════════════════════════════════════════════════════════════════════════

  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = variables.laptop.enable;
      };
    };
    
    # Use systemd-resolved for DNS resolution
    nameservers = lib.mkIf (!config.services.resolved.enable) 
      [ variables.dns.primary variables.dns.secondary ];
    
    # Enable systemd-resolved for better DNS handling
    resolvconf.enable = false;
    
    # Firewall
    firewall = {
      enable = variables.firewall.enable;
      allowedTCPPorts = variables.firewall.openPorts;
      allowedUDPPorts = variables.firewall.openUDPPorts;
      allowPing = variables.firewall.allowPing;
      logRefusedConnections = variables.firewall.logRefused;
    };
    
    # Enable WireGuard if configured
    wireguard.enable = variables.vpn.wireguard.enable;
  };

  # Systemd-resolved for DNS
  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "opportunistic";
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # HARDWARE
  # ═══════════════════════════════════════════════════════════════════════════

  # Audio (PipeWire)
  services.pipewire = lib.mkIf variables.hardware.audio {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };
  
  # Ensure PipeWire is used instead of PulseAudio
  services.pulseaudio.enable = false;

  # Bluetooth
  hardware.bluetooth = lib.mkIf variables.hardware.bluetooth {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        KernelExperimental = true;
      };
    };
  };

  # Graphics
  hardware.graphics = lib.mkIf variables.hardware.graphics {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; lib.optionals variables.hardware.videoAcceleration [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Printing
  services.printing = lib.mkIf variables.hardware.printing {
    enable = true;
    drivers = with pkgs; [ gutenprint hplip ];
  };
  
  # Enable CUPS browsing
  services.avahi = lib.mkIf variables.hardware.printing {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Scanning
  hardware.sane = lib.mkIf variables.hardware.scanning {
    enable = true;
    extraBackends = [ pkgs.sane-backends ];
  };

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
  
  # Docker
  virtualisation.docker = lib.mkIf variables.containers.docker {
    enable = true;
    storageDriver = variables.containers.dockerStorageDriver;
    enableOnBoot = variables.containers.dockerAutoStart;
  };
  
  # Podman
  virtualisation.podman = lib.mkIf variables.containers.podman {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # LAPTOP-SPECIFIC
  # ═══════════════════════════════════════════════════════════════════════════

  # Auto-detect laptop by checking for battery
  config.laptop.enable = lib.mkDefault (builtins.pathExists /sys/class/power_supply/BAT0);

  # Power management
  services.tlp = lib.mkIf config.laptop.enable {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 60;
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
      RESTORE_THRESHOLDS_ON_BAT = 1;
    };
  };

  # Power profiles daemon (alternative to TLP)
  services.power-profiles-daemon.enable = lib.mkIf 
    (config.laptop.enable && !config.services.tlp.enable) true;

  # Touchpad
  services.libinput = lib.mkIf config.laptop.enable {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
      accelProfile = "adaptive";
      accelSpeed = "0.5";
    };
  };

  # Better memory management for laptops
  services.earlyoom = lib.mkIf config.laptop.enable {
    enable = true;
    freeMemThreshold = 5;
    freeSwapThreshold = 10;
    preferRegex = "^(Web Content|Isolated Web Co)$";
  };

  # Auto-cpufreq for dynamic CPU frequency scaling
  services.auto-cpufreq = lib.mkIf config.laptop.enable {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };
      battery = {
        governor = "powersave";
        turbo = "auto";
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # DESKTOP ENVIRONMENT
  # ═══════════════════════════════════════════════════════════════════════════

  services.xserver.enable = true;
  
  # Display Manager
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = variables.displayManager.theme;
    };
    defaultSession = variables.defaultSession;
  };

  # KDE Plasma
  services.desktopManager.plasma6 = {
    enable = variables.desktopEnvironment == "plasma";
    enableQt5Integration = true;
  };

  # GNOME
  services.xserver.desktopManager.gnome = {
    enable = variables.desktopEnvironment == "gnome";
  };
  services.gnome = lib.mkIf (variables.desktopEnvironment == "gnome") {
    gnome-keyring.enable = true;
    tracker-miners.enable = true;
    tracker.enable = true;
  };

  # COSMIC (requires unstable channel)
  services.desktopManager.cosmic = {
    enable = variables.desktopEnvironment == "cosmic";
  };
  services.displayManager.cosmic-greeter = lib.mkIf (variables.desktopEnvironment == "cosmic") {
    enable = true;
  };

  # Hyprland
  programs.hyprland = {
    enable = variables.desktopEnvironment == "hyprland";
    withUWSM = true;
  };

  # Wayland support
  services.xserver.displayManager.gdm = lib.mkIf (variables.desktopEnvironment == "gnome") {
    enable = true;
    wayland = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # USER ACCOUNTS
  # ═══════════════════════════════════════════════════════════════════════════

  users.users.${variables.username} = {
    isNormalUser = true;
    description = variables.fullName;
    extraGroups = [ 
      "wheel" 
      "networkmanager" 
      "video"
      "audio"
    ] 
    ++ lib.optionals variables.hardware.virtualization [ "libvirtd" ]
    ++ lib.optionals variables.containers.docker [ "docker" ]
    ++ lib.optionals variables.containers.podman [ "podman" ]
    ++ lib.optionals variables.hardware.printing [ "lp" ]
    ++ lib.optionals variables.hardware.scanning [ "scanner" "lp" ];
    shell = pkgs.${variables.defaultShell};
    hashedPassword = variables.hashedPassword;
    openssh.authorizedKeys.keys = variables.sshAuthorizedKeys;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SECURITY
  # ═══════════════════════════════════════════════════════════════════════════

  security = {
    polkit.enable = true;
    sudo = {
      wheelNeedsPassword = variables.security.sudoNeedsPassword;
      execWheelOnly = true;
    };
    
    # PAM configuration
    pam = {
      services.swaylock = lib.mkIf (variables.desktopEnvironment == "hyprland") {};
      loginLimits = [
        { domain = "@wheel"; item = "nofile"; type = "soft"; value = "524288"; }
        { domain = "@wheel"; item = "nofile"; type = "hard"; value = "524288"; }
      ];
    };
    
    # rtkit for realtime audio
    rtkit.enable = variables.hardware.audio;
    
    # AppArmor
    apparmor = lib.mkIf variables.security.apparmor {
      enable = true;
      killUnconfinedConfinables = true;
    };
  };

  # SSH hardening
  services.openssh = lib.mkIf variables.security.sshHardening {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      PubkeyAuthentication = true;
      X11Forwarding = false;
    };
    openFirewall = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # NIX SETTINGS
  # ═══════════════════════════════════════════════════════════════════════════

  nix = {
    # Modern Nix features
    settings = {
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
      auto-optimise-store = true;
      keep-outputs = true;
      keep-derivations = true;
      max-jobs = "auto";
      cores = 0;  # Use all available cores
      substituters = variables.nix.substituters;
      trusted-public-keys = variables.nix.trustedPublicKeys;
    };

    # Garbage collection
    gc = lib.mkIf variables.gc.automatic {
      automatic = true;
      dates = variables.gc.frequency;
      options = "--delete-older-than ${variables.gc.olderThan}";
      persistent = true;
    };

    # Automatic store optimization
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
    };
    overlays = variables.nix.overlays;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SYSTEM PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════

  environment.systemPackages = with pkgs; [
    # Essential CLI tools
    wget
    curl
    git
    vim
    nano
    
    # Modern CLI replacements
    eza       # Better ls
    fd        # Better find
    ripgrep   # Better grep
    bat       # Better cat
    btop      # System monitor
    fastfetch # System info
    dust      # Better du
    duf       # Better df
    procs     # Better ps
    sd        # Better sed
    choose    # Better cut/awk
    
    # File management
    rsync
    tree
    fzf
    zoxide
    
    # Archives
    zip
    unzip
    p7zip
    unrar
    
    # System tools
    pciutils
    usbutils
    lshw
    dmidecode
    smartmontools
    
    # Network tools
    iperf3
    nmap
    tcpdump
    bind
    
    # Process management
    lsof
    strace
    htop
    
    # NH (Nix Helper)
    nh
    nix-output-monitor
    
    # Editor
    helix
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
        pull.rebase = variables.git.pullRebase;
        push.autoSetupRemote = true;
        core.autocrlf = "input";
        core.whitespace = "trailing-space,space-before-tab";
      };
    };

    # Shells
    fish = {
      enable = (variables.defaultShell == "fish");
      useBabelfish = true;
    };
    
    zsh = {
      enable = (variables.defaultShell == "zsh");
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
    
    bash = {
      completion.enable = true;
    };
    
    # Nix-ld for running unpatched binaries
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        fuse3
        icu
        nss
        openssl
        curl
        expat
      ];
    };
    
    # Dconf for GNOME settings
    dconf.enable = true;
    
    # KDE Connect
    kdeconnect = {
      enable = variables.desktopEnvironment == "plasma";
    };
    
    # Steam
    steam = lib.mkIf variables.gaming.steam {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = variables.gaming.gamescope;
    };
    
    # Gamemode for gaming performance
    gamemode = lib.mkIf variables.gaming.enable {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          amd_performance_level = "high";
        };
      };
    };
    
    # Firefox
    firefox = {
      enable = true;
      nativeMessagingHosts.packages = [ pkgs.plasma-browser-integration ];
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SERVICES
  # ═══════════════════════════════════════════════════════════════════════════

  # Flatpak repo
  services.flatpak.packages = [ ];
  
  # Flatpak remotes
  services.flatpak.remotes = lib.mkIf config.services.flatpak.enable [
    { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }
  ];

  # Update DB for locate command
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    localuser = null;
    interval = "daily";
    prunePaths = [ "/tmp" "/var/tmp" "/var/cache" "/var/lib/docker" "/var/lib/containers" "/nix/store" ];
  };

  # Fwupd (firmware updates)
  services.fwupd.enable = true;

  # Trim SSD weekly
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
  
  # Smartd for disk monitoring
  services.smartd = {
    enable = true;
    notifications.mail = {
      enable = variables.notifications.email.enable;
      recipient = variables.email;
    };
  };
  
  # Log rotation
  services.logrotate.enable = true;
  
  # Systemd journal
  services.journald = {
    extraConfig = ''
      SystemMaxUse=500M
      MaxFileSec=7day
    '';
  };
  
  # Thermald for thermal management
  services.thermald.enable = config.laptop.enable;

  # ═══════════════════════════════════════════════════════════════════════════
  # BACKUP
  # ═══════════════════════════════════════════════════════════════════════════

  services.borgbackup.jobs = lib.mkIf variables.backup.enable {
    homeBackup = {
      paths = variables.backup.paths;
      exclude = variables.backup.exclude;
      repo = variables.backup.repo;
      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat ${variables.backup.passFile}";
      };
      environment.BORG_RSH = "ssh -i ${variables.backup.sshKey}";
      compression = "auto,zstd,10";
      startAt = variables.backup.frequency;
      prune.keep = {
        within = "1d";
        daily = 7;
        weekly = 4;
        monthly = 6;
      };
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # CUSTOM MODULES & OVERRIDES
  # ═══════════════════════════════════════════════════════════════════════════

  # Allow unfree firmware
  hardware.enableRedistributableFirmware = true;
  
  # Enable all firmware
  hardware.firmware = with pkgs; [
    linux-firmware
    wireless-regdb
  ];

  # ZRAM for better memory management
  zramSwap = lib.mkIf variables.performance.zram {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Kernel same-page merging for memory deduplication
  hardware.ksm.enable = variables.performance.ksm;

  # ═══════════════════════════════════════════════════════════════════════════
  # DOCUMENTATION
  # ═══════════════════════════════════════════════════════════════════════════

  documentation = {
    enable = true;
    doc.enable = true;
    man.enable = true;
    info.enable = true;
    nixos.includeAllModules = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # ENVIRONMENT
  # ═══════════════════════════════════════════════════════════════════════════

  environment = {
    # Session variables
    sessionVariables = {
      EDITOR = variables.editor;
      VISUAL = variables.editor;
      PAGER = "less";
      LESS = "-R --mouse";
      SYSTEMD_PAGER = "";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORMTHEME = "gtk2";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      NIXOS_OZONE_WL = "1";
    };
    
    # Shell aliases
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      l = "ls -CF";
      ".." = "cd ..";
      "..." = "cd ../..";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      diff = "diff --color=auto";
      ip = "ip -color=auto";
    };
    
    # Paths to link
    pathsToLink = [ "/share/fish" "/share/zsh" "/share/bash-completion" ];
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # FONT CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      jetbrains-mono
      font-awesome
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" "Liberation Serif" ];
        sansSerif = [ "Noto Sans" "Liberation Sans" ];
        monospace = [ "JetBrains Mono" "Fira Code" "Liberation Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
      enable = true;
    };
  };
}
