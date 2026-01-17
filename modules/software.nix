{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat btop
    chromium curl
    discord
    eza
    fastfetch fd firefox fzf
    gamemode gcc
    kdePackages.partitionmanager kitty
    lazygit lutris
    nodejs
    qbittorrent
    reaper ripgrep
    spotify
    telegram-desktop tldr tor-browser tree
    unzip
    vim vscodium
    wget
    zoxide
  ];

  nixpkgs.config.allowUnfree = true;

  programs = {
    appimage = { enable = true; binfmt = true; };
    gamemode.enable = true;
    steam.enable = true;
    zsh.enable = true;
  };

  services.flatpak.enable = true;
}
