{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./stylix.nix
  ];

  home = {
    username = "f";
    homeDirectory = "/home/f";
    stateVersion = "25.05";
  };
}
