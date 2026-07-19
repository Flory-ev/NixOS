{ config, pkgs, ... }:
{
  # Boot
  boot = {
    initrd.systemd.enable = true;
    kernel.sysctl = {
      "kernel.dmesg_restrict" = true;
      "kernel.kptr_restrict" = 2;
      "kernel.unprivileged_bpf_disabled" = 1;

      "vm.max_map_count" = 2147483642;
      "vm.swappiness" = 10;
    };
    kernelParams = [
      "quiet"
      "amd_pstate=active"
      "nvidia-drm.fbdev=1"
    ];
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
  };

  powerManagement.cpuFreqGovernor = "performance";
  zramSwap.enable = true;

  # Security
  security.rtkit.enable = true;

  # System
  time.timeZone = "Europe/Copenhagen";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
  ];
  console.keyMap = "us";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dde0enMB6oXQ5yOtIyBTD6jLMOx3SoLDA=" ];
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";

  # Hardware
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };

    cpu.amd.updateMicrocode = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      open = true;
      powerManagement.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  # Networking
  networking = {
    hostName = "vortex";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi = {
        backend = "iwd";
        powersave = false;
      };
    };
    wireless.iwd = {
      enable = true;
      settings = {
        General.RoamRetryInterval = 15;
        Rank.BandModifier5Ghz = 2.0;
      };
    };
  };

  # Users
  users.users.f = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Services
  services = {
    displayManager.plasma-login-manager.enable = true;
    desktopManager.plasma6.enable = true;
    resolved.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 10;
    };
    flatpak.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
  };

  # Fonts
  fonts.packages = with pkgs; [
    font-awesome
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  # Programs
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    firefox.enable = true;
    nh = {
      enable = true;
      flake = "/home/f/nixos";
      clean = {
        enable = true;
        extraArgs = "--keep 3 --keep-since 4d";
      };
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
      ];
    };
    zsh.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
    };
    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = -10;
          softrealtime = "auto";
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          nv_powermizer_mode = 1;
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations activated'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations deactivated'";
        };
      };
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };

  # Environment
  environment.systemPackages = with pkgs; [
    nixfmt
  ];

  environment.sessionVariables = {
    WINE_FULLSCREEN_FSR = "1";
    WINE_FULLSCREEN_FSR_STRENGTH = "2";
    STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "0";
    PROTON_ENABLE_NVAPI = "1";
    PROTON_HIDE_NVIDIA_GPU = "0";
  };
}
