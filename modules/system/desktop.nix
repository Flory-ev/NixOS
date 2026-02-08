{ ... }:

{
  imports = [
    ./audio.nix
    ./fonts.nix
    ./hardware.nix
    ./programs.nix
    ./services.nix
  ];

  services = {
    displayManager.cosmic-greeter.enable = true;

    desktopManager.cosmic.enable = true;
  };
}
