{ config, lib, pkgs, ... }:

{
  boot = {
    extraModprobeConfig = "options kvm_intel nested=1";
    kernelModules = [ "kvm-amd" "kvm-intel" ];
  };

  environment.systemPackages = with pkgs; [
    OVMF
    qemu
    spice
    spice-gtk
    spice-protocol
    virt-manager
    virt-viewer
    virtio-win
    win-spice
  ];

  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
}
