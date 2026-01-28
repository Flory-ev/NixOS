{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./base.nix
    ../system/hardware/audio.nix
    ../system/hardware/graphics.nix
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    font-awesome
    jetbrains-mono
  ];

  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  services = {
    udisks2.enable = true;
    gvfs.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
  };
}
