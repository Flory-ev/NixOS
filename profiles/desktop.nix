{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./base.nix
    ../modules/system/audio.nix
    ../modules/system/graphics.nix
  ];

  programs.dconf.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
  ];
}
