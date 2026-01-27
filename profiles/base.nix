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

  # Glue options or minimal defaults can go here if strictly necessary
  # But primarily this file composes the 'Base' capability.
}
