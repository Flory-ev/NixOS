{ ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "stardust";

  # ── Intel CPU laptop ──────────────────────────────────────────────
  boot = {
    kernelModules = [ "kvm-intel" ];
    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
    ];
  };
}
