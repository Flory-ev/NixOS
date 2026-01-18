{ config, lib, pkgs, ... }:

{

	nix = {
    settings.experimental-features = [ "flakes" "nix-command" ];
    settings.auto-optimise-store = true;
  };

  system.stateVersion = "25.05";
}
