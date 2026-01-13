{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    #A

    #B
		bat btop
		#C
    chromium curl
    #D
		discord
    #E
		eza
    #F
		fastfetch fd firefox fzf
    #G
		gcc git
    #H

    #I

    #J

		#K
    kdePackages.partitionmanager kitty

    lazygit lutris
    #M
    nodejs   #N
    #O

		#P

		#Q
    qbittorrent
		#R
    ripgrep reaper
		#S
    spotify
		#T
    telegram-desktop tor-browser trdr tree
    #U
		unzip
		#V
    vim vscodium
		#W
    wget
    #X

    #Y

		#Z
    zoxide
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.steam.enable = true;
  programs.zsh.enable = true;

  services.flatpak.enable = true;
}
