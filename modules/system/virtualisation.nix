{
  config,
  lib,
  pkgs,
  ...
}:

{
  virtualisation = {
    # Docker configuration with enhanced settings
    docker = {
      enable = true;
      enableOnBoot = true;

      # Automatic cleanup settings
      autoPrune = {
        enable = true;
        flags = [
          "--all"
          "--filter"
          "until=24h"
        ];
        dates = "weekly";
      };
    };

    # Podman configuration with improved settings
    podman = {
      enable = true;

      # Network configuration
      defaultNetwork.settings.dns_enabled = true;
    };

    # libvirtd/QEMU configuration with comprehensive settings
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
      onBoot = "start";
      onShutdown = "shutdown";
    };

    # Spice support for better VM interaction
    spiceUSBRedirection.enable = true;
  };

  # Enable virt-manager
  programs.virt-manager.enable = true;

  # Hardware and kernel support for virtualization
  boot = {
    kernelModules = [
      "kvm-amd" # For AMD processors
      "kvm-intel" # For Intel processors
      "vfio-pci"
      "vhost-net"
      "tap"
      "tun"
    ];

    # Required for IOMMU and GPU passthrough if desired
    kernelParams = [
      "intel_iommu=on"
      "amd_iommu=on"
      "iommu=pt"
    ];
  };

  # User groups for virtualization
  users.users.f.extraGroups = [
    "docker"
    "libvirtd"
    "kvm"
    "input"
  ];

  /*
    # Optional: Dedicated storage pool for VMs
    # Only uncomment if you have a disk with this label
    fileSystems."/var/lib/libvirt/images" = {
      device = "/dev/disk/by-label/vm-images";
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
        "discard"
      ];
    };
  */

  # Environment variables for better experience
  environment = {
    systemPackages = with pkgs; [
      virt-viewer
      libguestfs
      guestfs-tools
      spice
      spice-gtk
      spice-protocol
      virtio-win
      win-spice
    ];

    sessionVariables = {
      # Improve libvirt performance
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };
  };
}
