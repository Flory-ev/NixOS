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
    ./home.nix
    ./networking.nix
    ./users.nix
  ];
}
