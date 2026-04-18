{ pkgs, ... }:
{
  # --- Virtualisation ---
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
      };
      onBoot = "start";
      onShutdown = "shutdown";
    };
    spiceUSBRedirection.enable = true;
  };
  environment = {
    systemPackages = with pkgs; [
      curl
      nixfmt
      wget
      spice
      spice-gtk
      virt-viewer
      virtio-win
      win-spice
    ];
    sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";
  };
}
