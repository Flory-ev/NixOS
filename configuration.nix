{
  config,
  lib,
  pkgs,
  inputs ? { },
  variables,
  ...
}:

let
  isLaptop = variables.laptop.enable || (builtins.pathExists /sys/class/power_supply/BAT0);
in

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = variables.hostname;
  system.stateVersion = variables.stateVersion;

  # Boot
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = variables.boot.configLimit;
        editor = false;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
      timeout = variables.boot.timeout;
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = lib.optionals variables.hardware.bluetooth [ "btusb" ];

    kernel.sysctl = lib.mkIf variables.security.hardening {
      "kernel.dmesg_restrict" = true;
      "kernel.kptr_restrict" = 2;
      "kernel.unprivileged_bpf_disabled" = 1;
    };

    consoleLogLevel = if variables.boot.silent then 0 else 3;
    kernelParams = lib.optionals variables.boot.silent [
      "quiet" "splash" "rd.systemd.show_status=false"
    ] ++ lib.optionals variables.boot.mitigations [ "mitigations=auto" ];

    plymouth = {
      enable = variables.boot.plymouth;
      theme = variables.boot.plymouthTheme;
    };

    tmp.cleanOnBoot = true;
    initrd = {
      systemd.enable = true;
      verbose = !variables.boot.silent;
    };
  };

  # Localization
  time.timeZone = variables.timezone;
  i18n.defaultLocale = variables.locale;
  i18n.supportedLocales = variables.supportedLocales;

  services.xserver.xkb = {
    layout = variables.keyboard.layout;
    variant = variables.keyboard.variant;
    options = variables.keyboard.options;
  };

  console = {
    font = variables.console.font;
    packages = [ pkgs.${variables.console.fontPackage} ];
  };

  # Networking
  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = isLaptop;
      };
    };
    firewall = {
      enable = variables.firewall.enable;
      allowedTCPPorts = variables.firewall.openPorts;
      allowedUDPPorts = variables.firewall.openUDPPorts;
      allowPing = variables.firewall.allowPing;
      logRefusedConnections = variables.firewall.logRefused;
    };
    wireguard.enable = variables.vpn.wireguard.enable;
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "true";
      DNSOverTLS = "opportunistic";
      FallbackDNS = "1.1.1.1 8.8.8.8";
    };
  };

  # Audio
  services.pipewire = lib.mkIf variables.hardware.audio {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = lib.mkIf variables.hardware.bluetooth {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  # Graphics
  hardware.graphics = lib.mkIf variables.hardware.graphics {
    enable = true;
    enable32Bit = true;
  };

  # Virtualization
  virtualisation.libvirtd = lib.mkIf variables.hardware.virtualization {
    enable = true;
    qemu.package = pkgs.qemu_kvm;
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

  # Laptop power management
  services.tlp = lib.mkIf isLaptop {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  services.power-profiles-daemon.enable = lib.mkForce false;

  services.libinput = lib.mkIf isLaptop {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
    };
  };

  services.earlyoom = lib.mkIf isLaptop {
    enable = true;
    freeMemThreshold = 5;
  };

  # Display Manager & Desktop
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  # Users
  users.users.${variables.username} = {
    isNormalUser = true;
    description = variables.fullName;
    extraGroups = [ "networkmanager" "wheel" ] 
      ++ lib.optional variables.hardware.virtualization "libvirtd"
      ++ lib.optional variables.containers.docker "docker";
    shell = pkgs.${variables.defaultShell};
  };

  security.sudo.wheelNeedsPassword = variables.security.sudoNeedsPassword;

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    substituters = variables.nix.substituters;
    trusted-public-keys = variables.nix.trustedPublicKeys;
  };

  nix.gc = lib.mkIf variables.gc.automatic {
    automatic = true;
    dates = variables.gc.frequency;
    options = "--delete-older-than ${variables.gc.olderThan}";
  };

  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    htop
    btop
    eza
    ripgrep
    fd
    fzf
    bat
    zoxide
    unzip
    zip
    p7zip
    killall
    lsof
    pciutils
    usbutils
    nh
    nix-output-monitor
    helix
  ] ++ variables.extraSystemPackages;

  # Programs
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };

    git = {
      enable = true;
      config = {
        init.defaultBranch = variables.git.defaultBranch;
        user.name = variables.fullName;
        user.email = variables.email;
        pull.rebase = variables.git.pullRebase;
        push.autoSetupRemote = true;
      };
    };

    zsh = {
      enable = (variables.defaultShell == "zsh");
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };

    bash.completion.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [ stdenv.cc.cc zlib ];
    };

    dconf.enable = true;
    kdeconnect.enable = true;

    steam = lib.mkIf variables.gaming.steam {
      enable = true;
      remotePlay.openFirewall = true;
    };

    gamemode = lib.mkIf variables.gaming.enable {
      enable = true;
    };

    firefox.enable = true;
  };

  # Services
  services.flatpak.enable = true;
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "daily";
  };
  services.fwupd.enable = true;
  services.fstrim.enable = true;
  services.smartd.enable = true;
  services.logrotate.enable = true;
  services.thermald.enable = isLaptop;

  # Firmware
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  # ZRAM & KSM
  zramSwap = lib.mkIf variables.performance.zram {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
  hardware.ksm.enable = variables.performance.ksm;

  # Environment
  environment.sessionVariables = {
    EDITOR = variables.editor;
    VISUAL = variables.editor;
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      fira-code
      jetbrains-mono
      font-awesome
    ];
    fontconfig.enable = true;
  };
}
