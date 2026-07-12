{ config, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "vortex";

  # ── AMD CPU + NVIDIA GPU desktop ───────────────────────────────────
  boot = {
    kernelModules = [ "kvm-amd" ];
    kernelParams = [
      # IOMMU passthrough — lower latency for VMs and direct device access
      "amd_iommu=on"
      "iommu=pt"

      # Disable mitigations for maximum gaming performance
      # WARNING: reduces security — only use on a personal gaming machine
      "mitigations=off"

      # AMD P-state driver — better power/perf scaling on Zen 2+
      "amd_pstate=active"

      # NVIDIA framebuffer and DRM modeset for Wayland compatibility
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];
  };

  # ─── Intel CPU — uncomment if this machine ever gets an Intel CPU ───
  # boot.kernelModules = [ "kvm-intel" ];
  # boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];

  # ── NVIDIA driver configuration (vortex-only: this is the only host ──
  # ── with an NVIDIA GPU — do NOT move this into the shared desktop  ──
  # ── module, or it gets forced onto non-NVIDIA hosts like stardust) ──
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    # Use the open-source NVIDIA kernel modules (supported on Turing+, i.e. RTX 20xx+)
    # Set to false if you have a Maxwell/Pascal card (GTX 9xx/10xx)
    open = true;

    # Enable the NVIDIA settings GUI
    nvidiaSettings = true;

    # Power management — saves power when GPU is idle (irrelevant on a desktop,
    # but harmless to leave on)
    powerManagement.enable = true;

    # Fine-grained power management (Turing+) — puts GPU to sleep when not in use.
    # Leave off on desktops; only worth enabling on laptops.
    powerManagement.finegrained = false;

    # Use the latest stable driver
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.sessionVariables = {
    PROTON_ENABLE_NVAPI = "1"; # expose NVIDIA API to games (DLSS, etc.)
    PROTON_HIDE_NVIDIA_GPU = "0"; # don't hide the GPU from DirectX games
  };
}
