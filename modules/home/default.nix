{ config, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./programs.nix
    ./services.nix
  ];

  home = {
    username = "f";
    homeDirectory = "/home/f";
    stateVersion = "25.05";
  };
}
