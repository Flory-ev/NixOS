{ pkgs, ... }:
{
  # --- Packages ---
  environment.systemPackages = with pkgs; [
    curl
    nixfmt
    wget
    spice
    spice-gtk
    virt-viewer
    virtio-win
    win-spice
  ];
}
