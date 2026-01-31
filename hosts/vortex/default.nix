{
  config,
  pkgs,
  inputs,
  variables,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/laptop.nix
  ];

  networking.hostName = variables.hostname;
}
