{ pkgs, ... }:

{
  home.packages = with pkgs; [
    antigravity
    bat
    bitwarden-desktop
    chromium
    discord
    eza
    fd
    fzf
    lutris
    nixfmt
    qbittorrent
    reaper
    spotify
    telegram-desktop
    thunderbird
    tor-browser
    tree
    veloren
    vlc
    vscodium
    zoxide
  ];
}
