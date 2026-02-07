{
  config,
  lib,
  pkgs,
  ...
}:

{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      storageDriver = "overlay2";
    };

    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
    };

    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

	
	programs = {
		virt-manager.enable = true;
	};
}
