{ pkgs, ... }:

{
  home.packages = with pkgs; [
    antigravity
    bitwarden-desktop
    chromium
    discord
    firefox
    kitty
    lutris
    ncdu
    qbittorrent
    reaper
    spotify
    telegram-desktop
    thunderbird
    tor-browser
    tree
    vlc
    vscodium
  ];
}
