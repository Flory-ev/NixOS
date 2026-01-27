{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/desktop.nix
    inputs.home-manager.nixosModules.home-manager
    ./host-modules/networking.nix
    ./host-modules/users.nix
    ./host-modules/home-manager.nix
  ];
}
