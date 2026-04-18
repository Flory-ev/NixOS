{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.nixfmt;
        };

      flake.nixosConfigurations.vortex = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          inputs.home-manager.nixosModules.home-manager
          ./nixos/boot.nix
          ./nixos/fonts.nix
          ./nixos/hardware.nix
          ./nixos/home.nix
          ./nixos/networking.nix
          ./nixos/nix.nix
          ./nixos/packages.nix
          ./nixos/programs.nix
          ./nixos/services.nix
          ./nixos/users.nix
          ./nixos/virtualisation.nix
        ];
      };
    };
}
