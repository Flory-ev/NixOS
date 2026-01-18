{ config, lib, pkgs, ... }:

{

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Copenhagen";
	i18n.defaultLocale = "en_US.UTF-8";

  security.rtkit.enable = true;
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

	nix = {
    settings.experimental-features = [ "flakes" "nix-command" ];
    settings.auto-optimise-store = true;
  };

	boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "25.05";
}
