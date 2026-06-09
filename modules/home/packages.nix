{ pkgs, ... }:

{
  home.packages = with pkgs; [
    antigravity
    bat
    discord
    eza
    fastfetch
    fd
    fzf
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
