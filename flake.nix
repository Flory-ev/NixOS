# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                           NixOS Flake Configuration                        ║
# ║                                                                             ║
# ║  This is the entry point for your NixOS system. It's simplified to just   ║
# ║  load variables.nix and pass them to configuration.nix and home.nix.      ║
# ║                                                                             ║
# ║  You rarely need to edit this - change settings in variables.nix instead. ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  description = "Simple NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      # Load all your settings from variables.nix
      variables = import ./variables.nix;
    in
    {
      nixosConfigurations.${variables.hostname} = nixpkgs.lib.nixosSystem {
        system = variables.system;
        
        specialArgs = { inherit variables; };
        
        modules = [
          # Main system configuration
          ./configuration.nix
          
          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit variables; };
            home-manager.users.${variables.username} = import ./home.nix;
          }
        ];
      };
    };
}
