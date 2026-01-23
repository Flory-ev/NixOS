{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    antigravity
    bat bitwarden-desktop btop
    chromium curl
    discord
    eza
    fastfetch fd firefox fzf
    kdePackages.partitionmanager kitty
    lazygit lutris
    ncdu nixfmt-rfc-style
    qbittorrent
    reaper ripgrep
    spotify
    telegram-desktop thunderbird tldr tor-browser tree
    unzip
    vim vlc vscodium
    wget
    zoxide
  ];

  nixpkgs.config.allowUnfree = true;

}
