{ pkgs, ... }:

{
  home.packages = with pkgs; [
    alacritty
    antigravity
    qbittorrent
    spotify
    sqlitebrowser
    termius
    telegram-desktop
    tor-browser
  ];
}
