{
  config,
  lib,
  pkgs,
  ...
}:

{
  virtualisation = {
    docker.enable = true;
    podman = {
      enable = true;
      # dockerCompat = true; # Conflicts with docker.enable
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd = {
      enable = true;
      # qemu.ovmf.enable = true; # Removed in recent NixOS, available by default
    };
  };

  programs.virt-manager.enable = true;

  boot.kernelModules = [
    "kvm-amd"
    "kvm-intel"
  ];

  users.users.f.extraGroups = [
    "docker"
    "libvirtd"
    "kvm"
  ];

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    libguestfs
  ];
}
