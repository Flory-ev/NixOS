{ config, pkgs, ... }:
{
  imports = [
    ./boot.nix
    ./environment.nix
    ./fonts.nix
    ./hardware.nix
    ./networking.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./system.nix
    ./users.nix
  ];
}
