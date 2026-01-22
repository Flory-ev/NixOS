{ config, lib, pkgs, ... }:

{
  nix = {
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = [ "flakes" "nix-command" ];
    };
  };

  system.stateVersion = "25.05";
}
