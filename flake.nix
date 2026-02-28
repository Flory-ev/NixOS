{
  description = "Vortex";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      unstable,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = import unstable {
        inherit system;
        config.allowUnfree = true;
      };

    in
    {
      nixosConfigurations.vortex = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs-unstable; };

        modules = [
          ./hardware-configuration.nix
          ./modules/system/boot.nix
          ./modules/system/default.nix
          ./modules/system/desktop.nix
          ./modules/system/networking.nix
          ./modules/system/users.nix
          ./modules/system/virtualisation.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = { inherit inputs pkgs-unstable; };
              useGlobalPkgs = false;
              useUserPackages = true;
              users.f = import ./modules/home/default.nix;
            };
          }
        ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
