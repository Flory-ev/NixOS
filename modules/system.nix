{ config, lib, pkgs, ... }:
{
  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Localization
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Copenhagen";

  # Nix settings
  nix = {
    settings.experimental-features = [ "flakes" "nix-command" ];
    settings.auto-optimise-store = true;
  };

  # Desktop environment (Plasma 6 + Wayland)
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.settings.General.DisplayServer = "wayland";

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    gwenview
    kwalletmanager
    okular
  ];

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [

  ];

  system.stateVersion = "25.05";
}
