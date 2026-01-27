{ pkgs, ... }:

{
  home.packages = with pkgs; [
    chromium
    firefox
    tor-browser
  ];

  # Future configuration for browsers can go here
  programs.firefox.enable = true;
}
