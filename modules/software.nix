{ config, lib, pkgs, ... }:

{
	
	#Packages
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
		gamemode gcc git
  #H

  #I

  #J

	#K
    kdePackages.partitionmanager kitty
	#L
    lazygit lutris
  #M

	#N
    nodejs
  #O

	#P

	#Q
    qbittorrent
	#R
    ripgrep reaper
	#S
    spotify
	#T
    telegram-desktop tor-browser tldr tree
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

	nixpkgs.config.allowUnfree = true;

	#Programs
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.zsh.enable = true;

	#Services
  services.flatpak.enable = true;

}
