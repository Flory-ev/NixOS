{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./programs.nix
    ./packages.nix
  ];

  home = {
    username = "f";
    homeDirectory = "/home/f";
    stateVersion = "25.05";
  };
}
