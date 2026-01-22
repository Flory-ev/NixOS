{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: 
  let
    mkSystem = host: system: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; }; 
      modules = [
        ./hosts/${host}/default.nix
        ./modules/system/imports.nix
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.f = import ./modules/user/home.nix;
          };
        }
      ];
    };
  in {
    nixosConfigurations = {
      solar-flare = mkSystem "solar-flare" "x86_64-linux";
      vortex = mkSystem "vortex" "x86_64-linux";
      nebula = mkSystem "nebula" "x86_64-linux";
      stardust = mkSystem "stardust" "x86_64-linux";
    };
  };
}