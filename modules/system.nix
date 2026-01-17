{ config, lib, pkgs, ... }:
{
  
	boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Copenhagen";

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };
	
	services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.settings.General.DisplayServer = "wayland";
  #services.displayManager.cosmic-greeter.enable = true;
  
	services.desktopManager.plasma6.enable = true;
  
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    gwenview
    kwalletmanager
    okular
  ];

	services.desktopManager.cosmic.enable = true;

	environment.cosmic.excludePackages = with pkgs; [
    
  ];
	
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/f/nixos";
  };
	
  nix = {
    settings.experimental-features = [ "flakes" "nix-command" ];
    settings.auto-optimise-store = true;
  };

  system.stateVersion = "25.05";
}
