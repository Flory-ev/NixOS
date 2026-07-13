{ pkgs, ... }:

{
  home.packages = with pkgs; [
    alacritty
    antigravity
    bat
    eza
    fastfetch
    fd
    fzf
    heroic
    qbittorrent
    reaper
    peazip
    spotify
    sqlitebrowser
    termius
    telegram-desktop
    tor-browser
    tree
    zoxide
  ];
}
