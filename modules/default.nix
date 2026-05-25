{ ... }:

{
  flake.nixosModules = {
    core = {
      imports = [
        ./core/boot.nix
        ./core/hardware.nix
        ./core/networking.nix
        ./core/nix.nix
        ./system/packages.nix
        ./system/services.nix
        ./system/users.nix
      ];
    };
    desktop = {
      imports = [
        ./desktop/fonts.nix
        ./desktop/programs.nix
      ];
    };
    home = {
      imports = [ ./home/default.nix ];
    };
  };
}
