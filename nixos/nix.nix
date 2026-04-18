{ ... }:
{
  # --- Nix ---
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dde0enMB6oXQ5yOtIyBTD6jLMOx3SoLDA=" ];
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
