{ pkgs, config, lib, ... }:
{
  # ╔══════════════════════════════════════════════════════════════════╗
  # ║                     GAMING OPTIMIZATIONS                        ║
  # ╚══════════════════════════════════════════════════════════════════╝

  # ── Kernel Tuning ──────────────────────────────────────────────────
  boot.kernel.sysctl = {
    # CS2, Star Citizen, and other large-world games need a huge map count
    "vm.max_map_count" = 2147483642;

    # Reduce swap aggressiveness — keep game data in RAM as long as possible
    "vm.swappiness" = 10;

    # Allow more dirty pages before flushing — reduces I/O stalls during gameplay
    "vm.dirty_ratio" = 20;
    "vm.dirty_background_ratio" = 10;

    # Disable watchdog timers — avoids unnecessary interrupts during gaming
    "kernel.nmi_watchdog" = 0;

    # Larger default/max socket buffer sizes — better for online multiplayer
    "net.core.rmem_default" = 1048576;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_default" = 1048576;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_rmem" = "4096 1048576 16777216";
    "net.ipv4.tcp_wmem" = "4096 1048576 16777216";

    # Enable TCP fast open for quicker connection setup
    "net.ipv4.tcp_fastopen" = 3;

    # Use BBR congestion control for better throughput
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";

    # Split lock detection can cause massive perf drops in some games
    "kernel.split_lock_mitigate" = 0;
  };

  # BBR requires the tcp_bbr module
  boot.kernelModules = [ "tcp_bbr" ];

  # ── CPU Performance ────────────────────────────────────────────────
  # Use the performance governor — maximum clocks, no power saving during gaming
  powerManagement.cpuFreqGovernor = "performance";

  # ── GameMode ───────────────────────────────────────────────────────
  # Feral GameMode — dynamic CPU/GPU governor switching on a per-game basis
  # (already enabled in programs.nix, configure its settings here)
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10; # give game processes higher priority
        softrealtime = "auto"; # enable SCHED_ISO when available
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        # NVIDIA-specific: set performance level to max while gaming
        nv_powermizer_mode = 1; # prefer maximum performance
        # AMD GPU — uncomment if switching to an AMD GPU in the future
        # amd_performance_level = "high";
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations activated'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations deactivated'";
      };
    };
  };

  # ── Gamescope ──────────────────────────────────────────────────────
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true; # allow gamescope to renice itself for lower latency
    };
    steam.gamescopeSession.enable = true;
  };

  # ── Gaming Packages ────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    mangohud     # FPS/perf overlay  (launch with MANGOHUD=1 %command%)
    protonup-qt  # manage Proton-GE versions
    winetricks   # Wine configuration helpers
    protontricks # Proton-specific winetricks wrapper
    vulkan-tools # vulkaninfo, vkcube — verify Vulkan is working
    mesa-demos   # check OpenGL renderer and driver version
  ];

  # ── Proton / Wine / NVIDIA Environment ─────────────────────────────
  environment.sessionVariables = {
    # AMD FSR — upscaling in Wine/Proton fullscreen games (works on all GPUs)
    WINE_FULLSCREEN_FSR = "1";
    WINE_FULLSCREEN_FSR_STRENGTH = "2"; # 0 = max sharpening, 5 = least

    # ─── NVIDIA-specific Proton variables ───
    PROTON_ENABLE_NVAPI = "1";   # expose NVIDIA API to games (DLSS, etc.)
    PROTON_HIDE_NVIDIA_GPU = "0"; # don't hide the GPU from DirectX games

    # ─── AMD GPU — uncomment when using an AMD GPU ───
    # RADV_PERFTEST = "aco";         # use ACO shader compiler (faster)
    # AMD_VULKAN_ICD = "RADV";       # prefer RADV Vulkan driver

    # ─── Intel GPU — uncomment when using an Intel GPU ───
    # ANV_VIDEO_DECODE = "1";        # enable hardware video decode on Intel

    # Shader pre-caching — let Steam download pre-compiled shaders
    STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "0";

    # Disable compositor bypass hints on Wayland — avoids flicker in some games
    SDL_VIDEODRIVER = "wayland,x11";
  };

  # ── Hardware: Graphics ─────────────────────────────────────────────
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # required for 32-bit games and Wine

    # Vulkan layers and OpenCL support
    extraPackages = with pkgs; [
      # ─── NVIDIA: Vulkan validation and compute ───
      vulkan-validation-layers

      # ─── AMD GPU — uncomment when using an AMD GPU ───
      # amdvlk                # alternative AMD Vulkan driver
      # rocmPackages.clr.icd  # OpenCL support via ROCm

      # ─── Intel GPU — uncomment when using an Intel GPU ───
      # intel-media-driver    # VA-API for hardware video decode
      # intel-compute-runtime # OpenCL support
    ];

    extraPackages32 = with pkgs.driversi686Linux; [
      # ─── AMD GPU 32-bit — uncomment when using an AMD GPU ───
      # amdvlk
    ];
  };

  # ── NVIDIA driver configuration ────────────────────────────────────
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    # Use the open-source NVIDIA kernel modules (supported on Turing+, i.e. RTX 20xx+)
    # Set to false if you have a Maxwell/Pascal card (GTX 9xx/10xx)
    open = true;

    # Enable the NVIDIA settings GUI
    nvidiaSettings = true;

    # Power management — saves power when GPU is idle (important for laptops)
    powerManagement.enable = true;

    # Fine-grained power management (Turing+) — puts GPU to sleep when not in use
    # Enable this on laptops, disable on desktops if it causes issues
    powerManagement.finegrained = false;

    # Use the latest stable driver
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # ─── AMD GPU driver — uncomment this block when using an AMD GPU ───
  # services.xserver.videoDrivers = [ "amdgpu" ];
  # hardware.amdgpu = {
  #   initrd.enable = true;       # load amdgpu early in initrd
  #   opencl.enable = true;       # OpenCL compute support
  #   amdvlk.enable = false;      # use RADV by default (better for gaming)
  # };

  # ─── Intel GPU — uncomment when using an Intel GPU ───
  # hardware.graphics.extraPackages = with pkgs; [
  #   intel-media-driver
  #   vaapiIntel
  # ];
}
