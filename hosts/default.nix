{ self, inputs, ... }:

{
  flake.nixosConfigurations = {
    vortex = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./vortex
        self.nixosModules.default
      ];
    };

    stardust = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./stardust
        self.nixosModules.default
      ];
    };
  };
}
