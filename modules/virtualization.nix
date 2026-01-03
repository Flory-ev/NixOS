{ config, pkgs, lib, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;  # TPM for Windows 11
    };
  };

  systemd.services.libvirtd-default-network = {
    description = "Setup libvirt default network";
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = ''
      ${pkgs.libvirt}/bin/virsh net-autostart default || true
      ${pkgs.libvirt}/bin/virsh net-start default || true
    '';
  };

  boot.kernelModules = [ "kvm-intel" "kvm-amd" ];
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    virtio-win
    spice
    spice-gtk
    spice-protocol
    win-spice
    qemu
    OVMF
  ];

  networking.bridges = {
    br0 = {
      interfaces = [ ];
    };
  };

  networking.interfaces.br0.useDHCP = true;

  virtualisation.spiceUSBRedirection.enable = true;

}
