{ pkgs, ... }:

{
  home.packages = with pkgs; [
    qbittorrent
    reaper
    spotify
    vlc
  ];
}
