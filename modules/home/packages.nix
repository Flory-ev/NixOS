{ pkgs, ... }:

{
  home.packages = with pkgs; [
    antigravity
    bat
    brightnessctl
    eza
    fastfetch
    fd
    fzf
    libnotify
    networkmanagerapplet
    qbittorrent
    libreoffice
    reaper
    spotify
    sqlitebrowser
    awww
    termius
    telegram-desktop
    tor-browser
    tree
    wl-clipboard
    zoxide
  ];
}
