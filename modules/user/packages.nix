{
  config,
  lib,
  pkgs,
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
