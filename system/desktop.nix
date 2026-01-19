{ config, lib, pkgs, ... }:

{
  environment = {
    cosmic.excludePackages = [ ];
    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      gwenview
      kwalletmanager
      okular
    ];
  };

  services = {
    desktopManager = {
      cosmic.enable = true;
      plasma6.enable = true;
    };

    displayManager = {
      cosmic-greeter.enable = true;
      defaultSession = "plasma";
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

}
