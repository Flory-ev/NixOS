# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  system/core/settings.nix - Nix & NixOS Settings                          ║
# ║                                                                             ║
# ║  Core Nix configuration:                                                    ║
# ║  - Flakes & nix-command (modern Nix features)                              ║
# ║  - Garbage collection (automatic cleanup)                                   ║
# ║  - Store optimization                                                       ║
# ║  - Unfree packages                                                          ║
# ║                                                                             ║
# ║  GC settings come from variables.nix                                        ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{ variables, ... }:
{
  nix = {

    # ─────────────────────────────────────────────────────────────────────────
    # NIX SETTINGS
    # ─────────────────────────────────────────────────────────────────────────

    settings = {
      # Automatically deduplicate files in the Nix store (saves disk space)
      auto-optimise-store = true;

      # Enable modern Nix features
      experimental-features = [
        "nix-command" # New CLI (nix build, nix shell, etc.)
        "flakes" # Reproducible configurations
      ];

      # Who can use Nix (root and wheel group)
      trusted-users = [
        "root"
        "@wheel"
      ];
    };

    # ─────────────────────────────────────────────────────────────────────────
    # GARBAGE COLLECTION
    # Automatically removes old system generations to free disk space
    # Settings from variables.nix
    # ─────────────────────────────────────────────────────────────────────────

    gc = {
      automatic = variables.gc.automatic;
      dates = variables.gc.frequency; # "daily", "weekly", "monthly"
      options = "--delete-older-than ${variables.gc.olderThan}";
    };

    # ─────────────────────────────────────────────────────────────────────────
    # STORE OPTIMIZATION
    # Runs periodically to remove duplicate files
    # ─────────────────────────────────────────────────────────────────────────

    optimise = {
      automatic = true;
      dates = [ variables.gc.frequency ];
    };
  };

  # ─────────────────────────────────────────────────────────────────────────────
  # NIXPKGS SETTINGS
  # ─────────────────────────────────────────────────────────────────────────────

  # Allow installing proprietary software (Steam, Discord, Spotify, etc.)
  nixpkgs.config.allowUnfree = true;

  # ─────────────────────────────────────────────────────────────────────────────
  # STATE VERSION
  # Don't change this after initial install!
  # ─────────────────────────────────────────────────────────────────────────────

  system.stateVersion = variables.stateVersion;
}
