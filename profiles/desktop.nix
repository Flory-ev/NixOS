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

  # Example of "Minimal Glue Option":
  # Enable dconf as it is a standard requirement for most GUI apps/settings
  programs.dconf.enable = true;

  # Install standard fonts required for a good desktop experience
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
  ];
}
