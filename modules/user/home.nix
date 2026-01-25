{
  config,
  lib,
  pkgs,
  inputs,
  user,
  ...
}:

{
  imports = [
    ./programs.nix
    ./packages.nix
  ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "25.05";
  };
}
