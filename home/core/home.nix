{ config, pkgs, ... }:
{
  imports = [
    ../software/packages.nix
    ../software/programs.nix
  ];

  home.stateVersion = "25.05";
}
