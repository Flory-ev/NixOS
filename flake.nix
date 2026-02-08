{
  description = "Vortex";

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

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nh,
      ...
    }:
      systems = [ "x86_64-linux" ];

      flake = {
        nixosConfigurations.vortex = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };

          modules = [
            ./hardware-configuration.nix
            ./modules/system/boot.nix
            ./modules/system/default.nix
            ./modules/system/desktop.nix
            ./modules/system/networking.nix
            ./modules/system/users.nix
            ./modules/system/virtualisation.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.f = import ./modules/home/default.nix;
              };
            }
          ];
        };
      };

      perSystem =
        { config, pkgs, ... }:
        {
          formatter = pkgs.nixfmt;
        };
    };
}
