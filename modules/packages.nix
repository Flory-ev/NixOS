{ config, lib, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
       #A
    bat btop   #B
    curl   #C
    discord   #D
    eza   #E
    fastfetch fd firefox fzf   #F
    gcc git   #G
       #H
       #I
       #J
    kdePackages.partitionmanager   #K
    lazygit   #L
       #M
    nodejs   #N
       #O
       #P
    qbittorrent   #Q
    ripgrep reaper   #R
    spotify   #S
    telegram-desktop tor-browser tree   #T
    unzip   #U
    vim vscode vscodium  #V
    wget  #W
       #X
       #Y
    zoxide   #Z
  ];
}
