{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cosmic-manager = {
      url = "github:HeitorAugustoLN/cosmic-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { nixpkgs, home-manager, cosmic-manager, ... }@inputs: 
  let
    mkSystem = host: user: system: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; }; 
      modules = [
        ./hosts/${host}/default.nix
        ./hosts/${host}/hardware.nix
        ./modules/system/imports.nix
        ./modules/user/imports.nix
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.${user} = import ./modules/user/home.nix;
          };
        }
      ];
    };
  in {
    nixosConfigurations = {
      solar-flare = mkSystem "solar-flare" "f" "x86_64-linux";
      vortex = mkSystem "vortex" "f" "x86_64-linux";
      nebula = mkSystem "nebula" "f" "x86_64-linux";
      stardust = mkSystem "stardust" "f" "x86_64-linux";
    };
  };
}