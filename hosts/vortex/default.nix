{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/laptop.nix
    inputs.home-manager.nixosModules.home-manager
    ./host-modules/networking.nix
    ./host-modules/users.nix
    ./host-modules/home.nix
  ];
}
