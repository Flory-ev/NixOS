{ self, inputs, ... }:

{
  flake.nixosConfigurations = {
    vortex = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./vortex
        self.nixosModules.core
        self.nixosModules.desktop
        self.nixosModules.home
      ];
    };

    stardust = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./stardust
        self.nixosModules.core
        self.nixosModules.desktop
        self.nixosModules.home
      ];
    };
  };
}
