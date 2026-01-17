{ config, lib, pkgs, ... }:

{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Copenhagen";

  nix = {
    settings.experimental-features = [ "flakes" "nix-command" ];
    settings.auto-optimise-store = true;
  };

  programs.nh = {
    enable = true;
    clean = { enable = true; extraArgs = "--keep-since 4d --keep 3"; };
    flake = "/home/f/nixos";
  };

  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      settings.General.DisplayServer = "wayland";
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

  security.rtkit.enable = true;
  system.stateVersion = "25.05";
}
