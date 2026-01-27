{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../modules/system/boot.nix
    ../modules/system/networking.nix
    ../modules/system/nix-settings.nix
    ../modules/system/locale.nix
    ../modules/system/security.nix
  ];
}
