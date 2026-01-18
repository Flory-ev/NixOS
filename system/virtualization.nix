{ config, pkgs, lib, ... }:

{
  boot = {
    extraModprobeConfig = "options kvm_intel nested=1";
    kernelModules = [ "kvm-amd" "kvm-intel" ];
  };

  environment.systemPackages = with pkgs; [
    OVMF
    qemu
    spice spice-gtk spice-protocol
    virt-manager virt-viewer virtio-win
		win-spice
  ];

  networking = {
    bridges.br0.interfaces = [ ];
    interfaces.br0.useDHCP = true;
  };

  programs.virt-manager.enable = true;

  systemd.services.libvirtd-default-network = {
    after = [ "libvirtd.service" ];
    description = "Setup libvirt default network";
    requires = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = { RemainAfterExit = "yes"; Type = "oneshot"; };
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
