{ config, lib, pkgs, ... }:

{
  environment = {
    cosmic.excludePackages = [ ];
    plasma6.excludePackages = with pkgs.kdePackages; [ elisa gwenview kwalletmanager okular ];
  };

  services = {
    desktopManager = {
      cosmic.enable = true;
      plasma6.enable = true;
    };
    displayManager = {
      cosmic-greeter.enable = true;
    };
    pipewire = {
      alsa.enable = true;
      enable = true;
      pulse.enable = true;
    };
  };
}