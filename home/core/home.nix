{ config, pkgs, ... }:
{
  imports = [
    ../software/packages.nix
    ../software/programs.nix
  ];

  home = {
    username = "f";
    homeDirectory = "/home/f";
    stateVersion = "25.05";
  };
}
