# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  flake.nix - NixOS Configuration Entry Point                              ║
# ║                                                                             ║
# ║  This is the "main" file of your NixOS config. It defines:                ║
# ║  - Where to get packages (nixpkgs, home-manager)                           ║
# ║  - How to build your system configuration                                  ║
# ║  - How to pass variables to all other config files                         ║
# ║                                                                             ║
# ║  You rarely need to edit this file - most changes go in variables.nix     ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  # ─────────────────────────────────────────────────────────────────────────────
  # INPUTS - Where we get our packages and tools from
  # ─────────────────────────────────────────────────────────────────────────────

  inputs = {
    # The main NixOS package repository (unstable = latest packages)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager - manages user-specific dotfiles and programs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Use same nixpkgs version
    };
  };

  # ─────────────────────────────────────────────────────────────────────────────
  # OUTPUTS - What this flake produces (your system configuration)
  # ─────────────────────────────────────────────────────────────────────────────

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      # Load your settings from variables.nix
      variables = import ./variables.nix;
    in
    {
      # Build a NixOS system configuration
      nixosConfigurations = {
        # Configuration named after your hostname (from variables.nix)
        ${variables.hostname} = nixpkgs.lib.nixosSystem {
          system = variables.system;

          # Pass variables to all NixOS modules
          specialArgs = { inherit inputs variables; };

          modules = [
            # Host-specific configuration
            ./hosts/${variables.hostname}

            # Enable Home Manager integration
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
