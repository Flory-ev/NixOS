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
  ];
  networking.hostName = "vortex";
}
