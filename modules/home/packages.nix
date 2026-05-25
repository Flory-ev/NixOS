{ pkgs, ... }:

{
  home.packages = with pkgs; [
    antigravity
    bat
    brightnessctl
    dunst
    eza
    fd
    fuzzel
    fzf
    libnotify
    networkmanagerapplet
    qbittorrent
    libreoffice
    reaper
    spotify
    sqlitebrowser
    swaylock
    awww
    termius
    telegram-desktop
    tor-browser
    tree
    waybar
    wl-clipboard
    zoxide
  ];
}
