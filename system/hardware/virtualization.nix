# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  system/hardware/virtualization.nix - VMs & Containers                   ║
# ║                                                                             ║
# ║  Enables running virtual machines with QEMU/KVM and virt-manager.         ║
# ║  Great for testing other OSes or running Windows apps.                    ║
# ║                                                                             ║
# ║  Enable/disable in variables.nix: hardware.virtualization                  ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  lib,
  pkgs,
  variables,
  ...
}:

# Only include this configuration if virtualization is enabled
lib.mkIf variables.hardware.virtualization {

  # ─────────────────────────────────────────────────────────────────────────────
  # KERNEL MODULES
  # Enable virtualization in the kernel
  # ─────────────────────────────────────────────────────────────────────────────

  boot = {
    # Enable nested virtualization (VMs inside VMs)
    extraModprobeConfig = "options kvm_intel nested=1";

    # Load KVM modules (works for both Intel and AMD)
    kernelModules = [
      "kvm-amd"
      "kvm-intel"
    ];
  };

  # ─────────────────────────────────────────────────────────────────────────────
  # VIRTUALIZATION PACKAGES
  # Tools for creating and managing VMs
  # ─────────────────────────────────────────────────────────────────────────────

  environment.systemPackages = with pkgs; [
    OVMF # UEFI firmware for VMs
    qemu # VM emulator
    spice # Remote display protocol
    spice-gtk # SPICE client
    spice-protocol
    virt-manager # GUI for managing VMs
    virt-viewer # VM display viewer
    virtio-win # Windows VM drivers
    win-spice # Windows SPICE tools
  ];

  # ─────────────────────────────────────────────────────────────────────────────
  # VIRT-MANAGER
  # GUI application for creating and managing virtual machines
  # ─────────────────────────────────────────────────────────────────────────────

  programs.virt-manager.enable = true;

  # ─────────────────────────────────────────────────────────────────────────────
  # LIBVIRT
  # Backend service for running VMs
  # ─────────────────────────────────────────────────────────────────────────────

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true; # Required for some features
        swtpm.enable = true; # TPM emulation (needed for Windows 11)
      };
    };

    # USB device passthrough to VMs
    spiceUSBRedirection.enable = true;
  };
}
