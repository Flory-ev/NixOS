{
  imports = [
    ../modules/system/.nix
    ../modules/system/.nix
    ../modules/system/.nix
    ../modules/system/.nix
    ../modules/system/.nix
  ];

  services.openssh.enable = true;

  programs.git.enable = true;

  system.stateVersion = "25.05";
}
