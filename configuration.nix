{ config, pkgs, ... }:
{
  imports = [
    ./modules/boot.nix
    ./modules/environment.nix
    ./modules/fonts.nix
    ./modules/hardware.nix
    ./modules/networking.nix
    ./modules/programs.nix
    ./modules/security.nix
    ./modules/services.nix
    ./modules/system.nix
    ./modules/users.nix
  ];
}
