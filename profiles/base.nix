{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../system/core/boot.nix
    ../system/core/settings.nix
    ../system/core/locale.nix
    ../system/core/security.nix
    ../system/software/packages.nix
  ];
}
