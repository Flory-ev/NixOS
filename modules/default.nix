{ ... }:

{
  flake.nixosModules = {
    default = {
      imports = [
        ./core/boot.nix
        ./core/hardware.nix
        ./core/networking.nix
        ./core/nix.nix
        ./desktop/fonts.nix
        ./desktop/home.nix
        ./desktop/programs.nix
        ./system/packages.nix
        ./system/services.nix
        ./system/users.nix
      ];
    };
  };
}
