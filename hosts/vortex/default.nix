{ ... }:

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
}
