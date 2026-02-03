{
  config,
  inputs ? { },
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    consoleLogLevel = 3;
    initrd = {
      systemd.enable = true;
      verbose = true;
    };
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
      systemd-boot = {
        configurationLimit = 10;
        consoleMode = "max";
        editor = false;
        enable = true;
      };
      timeout = 5;
    };
    plymouth = {
      enable = true;
      theme = "breeze";
    };
    tmp.cleanOnBoot = true;
  };

  console = {
    font = "Lat2-Terminus16";
    packages = [ pkgs.terminus_font ];
  };

  environment = {
    systemPackages = with pkgs; [
      bat
      btop
      curl
      eza
      fd
      fzf
      git
      helix
      htop
      killall
      lsof
      nh
      nix-output-monitor
      p7zip
      pciutils
      ripgrep
      unzip
      usbutils
      vim
      wget
      zip
      zoxide
    ];
  };

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

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  networking = {
    firewall = {
      allowPing = true;
      allowedTCPPorts = [ 7777 ];
      allowedUDPPorts = [ 7777 ];
      enable = true;
      logRefusedConnections = false;
    };
    hostName = "vortex";
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = false;
      };
    };
    wireguard.enable = false;
  };

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
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    appimage = {
      binfmt = true;
      enable = true;
    };
    firefox.enable = true;
    gamemode.enable = true;
    git = {
      config = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        user.email = "your.email@example.com";
        user.name = "Your Name";
      };
      enable = true;
    };
    kdeconnect.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [ stdenv.cc.cc zlib ];
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    virt-manager.enable = true;
    zsh = {
      autosuggestions.enable = true;
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
    };
  };

  security.sudo.wheelNeedsPassword = true;

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
    };
    flatpak.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = false;
        naturalScrolling = true;
        tapping = true;
      };
    };
    locate = {
      enable = true;
      interval = "daily";
      package = pkgs.plocate;
    };
    logrotate.enable = true;
    pipewire = {
      alsa = {
        enable = true;
        support32Bit = true;
      };
      enable = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    power-profiles-daemon.enable = lib.mkForce false;
    resolved = {
      enable = true;
      settings.Resolve = {
        DNSSEC = "true";
        DNSOverTLS = "opportunistic";
        FallbackDNS = "1.1.1.1 8.8.8.8";
      };
    };
    smartd.enable = true;
    thermald.enable = true;
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

  system.stateVersion = "25.05";

  time.timeZone = "Europe/Copenhagen";

  users.users.f = {
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
    isNormalUser = true;
    shell = pkgs.zsh;
  };

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

  zramSwap = {
    algorithm = "zstd";
    enable = true;
    memoryPercent = 50;
  };
}
