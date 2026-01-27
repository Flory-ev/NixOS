{ ... }:

{
  imports = [
    ./services/flatpak.nix
    ./services/printing.nix
    ./services/avahi.nix
    ./services/fwupd.nix
  ];
}
