{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      variables = import ./variables.nix;
    in
    {
      nixosConfigurations = {
        ${variables.hostname} = nixpkgs.lib.nixosSystem {
          system = variables.system;
          specialArgs = { inherit inputs variables; };
          modules = [
            ./hosts/${variables.hostname}
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit variables; };
              home-manager.users.${variables.username} = import ./home/core/home.nix;
            }
          ];
        };
      };
    };
}
