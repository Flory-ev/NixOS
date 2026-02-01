# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                           NixOS Flake Configuration                        ║
# ║                                                                             ║
# ║  This is the entry point for your NixOS system. It defines all external   ║
# ║  dependencies (inputs) and how they are combined to build your system.    ║
# ║                                                                             ║
# ║  You rarely need to edit this - change settings in variables.nix instead. ║
# ║                                                                             ║
# ║  Quick Commands:                                                           ║
# ║    nh os switch                    # Apply configuration                  ║
# ║    nh os switch --update           # Update and apply                     ║
# ║    nix flake update                # Update all inputs                    ║
# ║    nix flake lock --update-input X # Update specific input                ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  description = "Modular NixOS Configuration with Centralized Settings";

  # ============================================================================
  # INPUTS - External dependencies and package sources
  # ============================================================================
  # These are the building blocks that your configuration uses.
  # Each input is a Git repository that provides packages or modules.

  inputs = {
    # ─────────────────────────────────────────────────────────────────────────
    # Core NixOS Packages
    # ─────────────────────────────────────────────────────────────────────────
    # The main NixOS package repository
    # Channels: nixos-unstable, nixos-25.05, nixos-25.11, etc.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Alternative nixpkgs for specific use cases
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    # ─────────────────────────────────────────────────────────────────────────
    # Home Manager
    # ─────────────────────────────────────────────────────────────────────────
    # Manages user environment (dotfiles, user packages, program configs)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # Community Flakes
    # ─────────────────────────────────────────────────────────────────────────

    # NUR (Nix User Repository) - Community packages
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware-specific configurations
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Flatpak support for NixOS
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # Desktop Environments
    # ─────────────────────────────────────────────────────────────────────────

    # COSMIC Desktop Environment (System76)
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland Wayland compositor
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland plugins and utilities
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # Hyprspace - overview plugin for Hyprland
    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # Development Tools
    # ─────────────────────────────────────────────────────────────────────────

    # Devenv - Development environment manager
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko - Declarative disk partitioning
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence - Ephemeral root with persistent data
    impermanence = {
      url = "github:nix-community/impermanence";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # Secrets Management
    # ─────────────────────────────────────────────────────────────────────────

    # SOPS-Nix - Secrets management with SOPS
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # Theming & Customization
    # ─────────────────────────────────────────────────────────────────────────

    # Catppuccin theme for various applications
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix - Theming framework
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Spicetify - Spotify theming
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # Neovim Configuration
    # ─────────────────────────────────────────────────────────────────────────

    # NixVim - Neovim configured with Nix
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # Other Utilities
    # ─────────────────────────────────────────────────────────────────────────

    # NH - Nix helper CLI tool
    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix-index-database - Pre-built nix-index database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pre-commit hooks for Nix
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ============================================================================
  # OUTPUTS - What this flake produces
  # ============================================================================
  # This section defines how inputs are combined to create your system.

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      # ───────────────────────────────────────────────────────────────────────
      # Load Configuration Variables
      # ───────────────────────────────────────────────────────────────────────
      # Import your centralized settings from variables.nix
      variables = import ./variables.nix;

      # ───────────────────────────────────────────────────────────────────────
      # Helper Functions
      # ───────────────────────────────────────────────────────────────────────

      # Create nixpkgs instance with overlays
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowBroken = false;
            allowUnsupportedSystem = false;
          };
          overlays = [
            inputs.nur.overlay
            inputs.nh.overlays.default
            inputs.catppuccin.overlays.default
          ]
          ++ variables.nix.overlays;
        };

      # Supported systems
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      # Helper to map over systems
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # ───────────────────────────────────────────────────────────────────────
      # Special Arguments (passed to all modules)
      # ───────────────────────────────────────────────────────────────────────
      specialArgs = {
        inherit inputs variables;
      };

      # ───────────────────────────────────────────────────────────────────────
      # Common NixOS Modules
      # ───────────────────────────────────────────────────────────────────────
      commonNixosModules = [
        # Home Manager integration
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = specialArgs;
            users.${variables.username} = import ./home.nix;
          };
        }

        # NUR (Nix User Repository)
        { nixpkgs.overlays = [ inputs.nur.overlay ]; }

        # SOPS secrets management (optional)
        inputs.sops-nix.nixosModules.sops

        # Flatpak support (optional)
        inputs.nix-flatpak.nixosModules.nix-flatpak

        # Catppuccin theming (optional)
        inputs.catppuccin.nixosModules.catppuccin

        # Disko partitioning (optional)
        inputs.disko.nixosModules.disko
      ];
    in
    {
      # ───────────────────────────────────────────────────────────────────────
      # NixOS Configurations
      # ───────────────────────────────────────────────────────────────────────
      # Define your NixOS systems here

      nixosConfigurations = {
        # Primary system configuration
        ${variables.hostname} = nixpkgs.lib.nixosSystem {
          system = variables.system;
          specialArgs = specialArgs;
          modules = commonNixosModules ++ [
            # Main system configuration
            ./configuration.nix

            # Hardware configuration (auto-generated)
            ./hardware-configuration.nix

            # Optional: COSMIC desktop
            (nixpkgs.lib.mkIf (
              variables.desktopEnvironment == "cosmic"
            ) inputs.nixos-cosmic.nixosModules.default)

            # Optional: Hyprland
            (nixpkgs.lib.mkIf (variables.desktopEnvironment == "hyprland") inputs.hyprland.nixosModules.default)
          ];
        };

        # Example: Additional host configuration
        # Uncomment and modify to add more computers
        # "laptop" = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   specialArgs = specialArgs;
        #   modules = commonNixosModules ++ [
        #     ./hosts/laptop
        #   ];
        # };
      };

      # ───────────────────────────────────────────────────────────────────────
      # Home Configurations (standalone Home Manager)
      # ───────────────────────────────────────────────────────────────────────
      # Use these on non-NixOS systems with Home Manager

      homeConfigurations = {
        ${variables.username} = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs variables.system;
          extraSpecialArgs = specialArgs;
          modules = [
            ./home.nix
            inputs.catppuccin.homeModules.catppuccin
            inputs.nixvim.homeModules.nixvim
            inputs.spicetify-nix.homeManagerModules.default
          ];
        };
      };

      # ───────────────────────────────────────────────────────────────────────
      # Development Shells
      # ───────────────────────────────────────────────────────────────────────
      # Shell environments for working on this configuration

      devShells = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
        in
        {
          # Default development shell
          default = pkgs.mkShell {
            name = "nixos-config";
            packages = with pkgs; [
              # Nix tools
              nix-output-monitor
              nix-tree
              nix-diff
              nix-prefetch-git
              nix-prefetch-github

              # Formatting and linting
              nixpkgs-fmt
              statix
              deadnix
              alejandra

              # Helpers
              nh
              just
              gnumake

              # Editor support
              nil
              nixd

              # Git hooks
              git
              pre-commit
            ];

            shellHook = ''
              echo "🎉 Welcome to the NixOS Config Development Shell!"
              echo ""
              echo "Available commands:"
              echo "  nh os switch        - Apply configuration"
              echo "  nh os switch -u     - Update and apply"
              echo "  nix flake update    - Update all inputs"
              echo "  nixpkgs-fmt .       - Format all Nix files"
              echo "  statix check .      - Lint Nix files"
              echo "  deadnix .           - Find unused Nix code"
              echo ""
              echo "Current hostname: ${variables.hostname}"
              echo "Current system: ${system}"
            '';
          };

          # Minimal shell with just essential tools
          minimal = pkgs.mkShell {
            name = "nixos-config-minimal";
            packages = with pkgs; [
              nh
              nixpkgs-fmt
            ];
          };
        }
      );

      # ───────────────────────────────────────────────────────────────────────
      # Packages
      # ───────────────────────────────────────────────────────────────────────
      # Custom packages exposed by this flake

      packages = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
        in
        {
          # Example: Custom package
          # my-script = pkgs.callPackage ./pkgs/my-script { };
        }
      );

      # ───────────────────────────────────────────────────────────────────────
      # Formatter
      # ───────────────────────────────────────────────────────────────────────
      # Default formatter for this flake

      formatter = forAllSystems (system: (mkPkgs system).nixpkgs-fmt);

      # ───────────────────────────────────────────────────────────────────────
      # Checks
      # ───────────────────────────────────────────────────────────────────────
      # Pre-commit hooks and CI checks

      checks = forAllSystems (
        system:
        let
          pkgs = mkPkgs system;
        in
        {
          # Nix formatting check
          formatting = pkgs.runCommand "check-formatting" { buildInputs = [ pkgs.nixpkgs-fmt ]; } ''
            ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}
            touch $out
          '';

          # Statix linting
          statix = pkgs.runCommand "check-statix" { buildInputs = [ pkgs.statix ]; } ''
            ${pkgs.statix}/bin/statix check ${./.}
            touch $out
          '';

          # Dead code detection
          deadnix = pkgs.runCommand "check-deadnix" { buildInputs = [ pkgs.deadnix ]; } ''
            ${pkgs.deadnix}/bin/deadnix ${./.}
            touch $out
          '';
        }
      );

      # ───────────────────────────────────────────────────────────────────────
      # Templates
      # ───────────────────────────────────────────────────────────────────────
      # Reusable templates for new projects

      templates = {
        # Minimal NixOS configuration template
        minimal = {
          path = ./templates/minimal;
          description = "Minimal NixOS configuration with flakes";
        };

        # Full desktop configuration template
        desktop = {
          path = ./templates/desktop;
          description = "Full desktop NixOS configuration";
        };

        # Server configuration template
        server = {
          path = ./templates/server;
          description = "Server-optimized NixOS configuration";
        };
      };

      # Default template
      defaultTemplate = self.templates.minimal;
    };

  # ============================================================================
  # NIX CONFIG
  # ============================================================================
  # Settings for the nix command itself

  nixConfig = {
    # Binary caches to use
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cosmic.cachix.org"
      "https://hyprland.cachix.org"
      "https://devenv.cachix.org"
      "https://cache.garnix.io"
    ];

    # Trusted public keys for the caches
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cosmic.cachix.org-1:Dya9IyXD4D8E/ajZ0NVzW7A0D7wZGlMiJf8lyvECyRo="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "cache.garnix.io:CTFPyKsxmcj8TVB0RQmZQM9E7G6N4nj+S0n00gpmB10="
    ];

    # Allow these settings in user configuration
    accept-flake-config = true;
  };
}
