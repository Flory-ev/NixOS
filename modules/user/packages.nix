{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    # Add your user-specific packages here
    # Example:
    # firefox
    # vlc
  ];
}
