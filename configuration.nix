{ config, pkgs, ... }:
{
  # ============================================================
  # Boot / kernel
  # ============================================================
  boot = {
    initrd.systemd.enable = true;
    kernel.sysctl = {
      "kernel.dmesg_restrict" = true;
      "kernel.kptr_restrict" = 2;
      "kernel.unprivileged_bpf_disabled" = 1;

      # CS2, Star Citizen, and other large-world games need a huge map count
      "vm.max_map_count" = 2147483642;
      # Reduce swap aggressiveness — keep game data in RAM as long as possible
      "vm.swappiness" = 10;
    };
    kernelModules = [ "btusb" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "amd_pstate=active"
      "nvidia-drm.modeset=1"
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
  zramSwap.enable = true;

  # ============================================================
  # System / locale
  # ============================================================
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

  # ============================================================
  # Hardware
  # ============================================================
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };

    # Graphics / NVIDIA
    graphics = {
      enable = true;
      enable32Bit = true; # required for 32-bit games and Wine
    };

    nvidia = {
      modesetting.enable = true;
      # Use the open-source NVIDIA kernel modules (supported on Turing+, i.e. RTX 20xx+)
      # Set to false if you have a Maxwell/Pascal card (GTX 9xx/10xx)
      open = true;
      nvidiaSettings = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false; # only worth enabling on laptops
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # ============================================================
  # Networking
  # ============================================================
  networking = {
    hostName = "vortex";
    firewall = {
      allowedTCPPorts = [ 7777 ];
      allowedUDPPorts = [ 7777 ];
    };
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
        Rank.BandModifier5Ghz = 2.0; # strongly prefer 5 GHz networks
      };
    };
  };

  # ============================================================
  # Users
  # ============================================================
  users.users.f = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "input"
      "networkmanager"
      "video"
      "wheel"
    ];
  };

  # ============================================================
  # Services
  # ============================================================
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
  };

  security.polkit.enable = true;

  # ============================================================
  # Fonts
  # ============================================================
  fonts.packages = with pkgs; [
    fira-code
    font-awesome
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  # ============================================================
  # Gaming
  # ============================================================
  powerManagement.cpuFreqGovernor = "performance";

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
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      gamescopeSession.enable = true;
    };

    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10; # give game processes higher priority
          softrealtime = "auto"; # enable SCHED_ISO when available
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          nv_powermizer_mode = 1; # NVIDIA: prefer maximum performance
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations activated'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations deactivated'";
        };
      };
    };

    gamescope = {
      enable = true;
      capSysNice = true; # allow gamescope to renice itself for lower latency
    };
  };

  # Fix for "mouse doesn't work in games": xwayland-satellite has a known
  # cursor-grab bug (github.com/Supreeeme/xwayland-satellite#219). Per-game
  # in Steam -> Properties -> Launch Options:
  #   gamescope -f -W 2560 -H 1440 --force-grab-cursor --backend sdl -- %command%

  environment.sessionVariables = {
    WINE_FULLSCREEN_FSR = "1"; # AMD FSR upscaling in Wine/Proton fullscreen games
    WINE_FULLSCREEN_FSR_STRENGTH = "2"; # 0 = max sharpening, 5 = least
    STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "0"; # let Steam use its own shader cache
    SDL_VIDEODRIVER = "wayland,x11"; # avoids flicker in some games on Wayland
    PROTON_ENABLE_NVAPI = "1"; # expose NVIDIA API to games (DLSS, etc.)
    PROTON_HIDE_NVIDIA_GPU = "0"; # don't hide the GPU from DirectX games
  };

  environment.systemPackages = with pkgs; [
    nixfmt
    mangohud # FPS/perf overlay (launch with MANGOHUD=1 %command%)
    protonup-qt # manage Proton-GE versions
    winetricks # Wine configuration helpers
    protontricks # Proton-specific winetricks wrapper
    vulkan-tools # vulkaninfo, vkcube — verify Vulkan is working
    mesa-demos # check OpenGL renderer and driver version
  ];
}
