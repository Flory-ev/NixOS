{ pkgs, ... }:

{
  home.packages = with pkgs; [
    antigravity
    bat
    eza
    fastfetch
    fd
    fzf
    heroic
    qbittorrent
    reaper
    spotify
    sqlitebrowser
    termius
    telegram-desktop
    tor-browser
    tree
    zoxide
  ];
}
