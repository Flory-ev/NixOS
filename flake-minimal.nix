{
  description = "Minimal NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      variables = import ./variables.nix;
      
      specialArgs = { inherit inputs variables; };
    in
    {
      nixosConfigurations.${variables.hostname} = nixpkgs.lib.nixosSystem {
        system = variables.system;
        specialArgs = specialArgs;
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = specialArgs;
              users.${variables.username} = import ./home.nix;
            };
          }
        ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [ 
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" 
    ];
  };
}
