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
      storageDriver = "overlay2";
      
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
      
      # Daemon configuration
      daemon.settings = {
        # Network and performance settings
        log-driver = "journald";
        log-opts = {
          tag = "{{.ImageName}}/{{.ContainerName}}";
          max-size = "10m";
          max-file = "3";
        };
        
        # Registry mirrors (common ones)
        registry-mirrors = [
          "https://mirror.gcr.io"
          "https://docker.mirrors.ustc.edu.cn"
        ];
        
        # Performance optimizations
        live-restore = true;
        default-ulimits = {
          nofile = 65536;
          nproc = 65536;
        };
        
        # Security hardening
        seccomp-profile = "${pkgs.docker sealing}/resources/etc/docker/seccomp.profile";
      };
      
      # Privileged containers support
      privileged = false;
    };

    # Podman configuration with improved settings
    podman = {
      enable = true;
      
      # Network configuration
      defaultNetwork.settings.dns_enabled = true;
      
      # Docker compatibility
      dockerCompatible = true;
      
      # Socket activation
      enableSocket = true;
      
      # Machine settings (for podman machine)
      machine = {
        enable = true;
        memory = 4096;
        cpus = 2;
        diskSize = 10;
      };
    };

    # libvirtd/QEMU configuration with comprehensive settings
    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
      
      # Security and isolation settings
      onBoot = "start";
      onShutdown = "shutdown";
      
      # Required for hardware acceleration
      ovmf.enable = true;
      
      # Networking settings
      network = {
        enable = true;
        nat = true;
        addresses = ["192.168.122.0/24"];
      };
    };
  };

  # Enable virt-manager
  programs = {
    virt-manager.enable = true;
  };
  
  # Hardware and kernel support for virtualization
  boot = {
    kernelModules = [
      "kvm-amd"      # For AMD processors
      "kvm-intel"    # For Intel processors
      "vfio-pci"
      "vhost-net"
      "tap"
      "tun"
    ];
    
    extraModulePackages = [
      # For GPU passthrough if needed
      config.boot.kernelPackages.vfio-pci
      config.boot.kernelPackages.vfio vfio_virqfd
    ];
  };
  
  # Required services
  services = {
    # libvirtd daemon
    libvirtd = {
      enable = true;
      autostart = true;
      extraOptions = [
        "--listen"
      ];
    };
    
    # Optional: Add SSH access for remote management
    openssh = {
      enable = true;
      ports = 22;
    };
  };
  
  # User groups for virtualization
  users.users = {
    # Add your username here
    yourusername = {
      extraGroups = [
        "docker"
        "libvirtd"
        "kvm"
        "input"
      ];
    };
  };
  
  # File systems for VM storage
  fileSystems = {
    # Optional: Dedicated storage pool for VMs
    "/var/lib/libvirt/images" = {
      device = "/dev/disk/by-label/vm-images";
      fsType = "ext4";
      options = ["noatime", "nodiratime", "discard"];
    };
  };
  
  # Environment variables for better experience
  environment = {
    systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      libguestfs
      guestfs-tools
    ];
    
    sessionVariables = {
      # Improve libvirt performance
      LIBVIRT_DEFAULT_URI = "qemu:///system";
    };
  };
  
  # Optional: Thermal management for VMs
  services.thermald.enable = false;
  
  # ZFS support for storage pools (if using ZFS)
  # services.zfs.autoScrub.enable = false;
}
