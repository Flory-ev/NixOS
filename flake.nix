{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./system/boot.nix
				./system/configuration.nix
        ./system/desktop.nix
        ./system/hardware.nix
        ./system/locale.nix
        ./system/networking.nix
        ./system/virtualization.nix
        
        ./user/packages.nix
        ./user/programs.nix
        ./user/services.nix
        ./user/users.nix
        
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.f = import ./user/home.nix;
        }
      ];
    };
  };
}
