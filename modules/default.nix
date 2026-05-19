{ ... }:

{
  flake.nixosModules = {
    default = {
      imports = [
        ./boot.nix
        ./fonts.nix
        ./hardware.nix
        ./home.nix
        ./networking.nix
        ./nix.nix
        ./packages.nix
        ./programs.nix
        ./services.nix
        ./users.nix
        ./virtualisation.nix
      ];
    };
  };
}
