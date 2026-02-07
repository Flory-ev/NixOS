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

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      flake-parts,
      nh,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      flake = {
        nixosConfigurations.vortex = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };

          modules = [
            ./hardware-configuration.nix
            ./system/boot.nix
            ./system/default.nix
            ./system/desktop.nix
            ./system/networking.nix
            ./system/users.nix
            ./system/virtualisation.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                useGlobalPkgs = true;
                useUserPackages = true;
                users.f = import ./home/f/default.nix;
              };
            }
          ];
        };
      };

      perSystem =
        { config, pkgs, ... }:
        {
          formatter = pkgs.nixfmt-classic;
        };
    };
}
