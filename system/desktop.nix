{ config, lib, pkgs, ... }:

{

services = {
    displayManager = {
      cosmic-greeter.enable = true;
    };
    desktopManager = {
      plasma6.enable = true;
      cosmic.enable = true;
    };
		pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [ elisa gwenview kwalletmanager okular ];
    cosmic.excludePackages = [ ];
  };

}