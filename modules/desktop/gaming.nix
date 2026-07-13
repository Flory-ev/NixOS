{ pkgs, ... }:
{
  # ── Kernel Tuning ──────────────────────────────────────────────────
  boot.kernel.sysctl = {
    # CS2, Star Citizen, and other large-world games need a huge map count
    "vm.max_map_count" = 2147483642;

    # Reduce swap aggressiveness — keep game data in RAM as long as possible
    "vm.swappiness" = 10;
  };

  # ── CPU Performance ────────────────────────────────────────────────
  # Use the performance governor — maximum clocks, no power saving during gaming
  powerManagement.cpuFreqGovernor = "performance";

  # ── GameMode ───────────────────────────────────────────────────────
  # Feral GameMode — dynamic CPU/GPU governor switching on a per-game basis
  # (enabled in programs.nix, configured here)
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
        nv_powermizer_mode = 1; # NVIDIA: prefer maximum performance
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations activated'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations deactivated'";
      };
    };
  };

  # ── Gamescope ──────────────────────────────────────────────────────
  # Fix for "mouse doesn't work in games": xwayland-satellite has a known
  # cursor-grab bug (github.com/Supreeeme/xwayland-satellite#219). Per-game
  # in Steam -> Properties -> Launch Options:
  #   gamescope -f -W 2560 -H 1440 --force-grab-cursor --backend sdl -- %command%
  # Or just log in via the "Steam Big Picture" gamescope session below.
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true; # allow gamescope to renice itself for lower latency
    };
    steam.gamescopeSession.enable = true;
  };

  # ── Gaming Packages ────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    mangohud # FPS/perf overlay (launch with MANGOHUD=1 %command%)
    protonup-qt # manage Proton-GE versions
    winetricks # Wine configuration helpers
    protontricks # Proton-specific winetricks wrapper
    vulkan-tools # vulkaninfo, vkcube — verify Vulkan is working
    mesa-demos # check OpenGL renderer and driver version
  ];

  # ── Proton / Wine Environment ──────────────────────────────────────
  # NVIDIA-specific Proton variables live in configuration.nix.
  environment.sessionVariables = {
    WINE_FULLSCREEN_FSR = "1"; # AMD FSR upscaling in Wine/Proton fullscreen games
    WINE_FULLSCREEN_FSR_STRENGTH = "2"; # 0 = max sharpening, 5 = least
    STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "0"; # let Steam use its own shader cache
    SDL_VIDEODRIVER = "wayland,x11"; # avoids flicker in some games on Wayland
  };

  # ── Hardware: Graphics ─────────────────────────────────────────────
  # NVIDIA driver config (services.xserver.videoDrivers, hardware.nvidia)
  # lives in configuration.nix as it's host-specific.
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # required for 32-bit games and Wine
  };
}
