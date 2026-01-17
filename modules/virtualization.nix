{ config, pkgs, lib, ... }:

{
  boot = {
    kernelModules = [ "kvm-intel" "kvm-amd" ];
    extraModprobeConfig = "options kvm_intel nested=1";
  };

  environment.systemPackages = with pkgs; [
    OVMF qemu spice spice-gtk spice-protocol
    virt-manager virt-viewer virtio-win win-spice
  ];

  networking = {
    bridges.br0.interfaces = [ ];
    interfaces.br0.useDHCP = true;
  };

  programs.virt-manager.enable = true;

  systemd.services.libvirtd-default-network = {
    description = "Setup libvirt default network";
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = { Type = "oneshot"; RemainAfterExit = "yes"; };
    script = ''
      ${pkgs.libvirt}/bin/virsh net-autostart default || true
      ${pkgs.libvirt}/bin/virsh net-start default || true
    '';
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = { package = pkgs.qemu_kvm; runAsRoot = true; swtpm.enable = true; };
    };
    spiceUSBRedirection.enable = true;
  };
}
