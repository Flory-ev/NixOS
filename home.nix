{ pkgs, ... }:

{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    antigravity
    bitwarden-desktop
    chromium
    discord
    firefox
    kitty
    lutris
    qbittorrent
    reaper
    spotify
    telegram-desktop
    thunderbird
    tor-browser
    vlc
    vscodium
  ];

  programs = {
    git = {
      enable = true;
			settings = {
				user = {
				  name = "F";
		      mail = "vladislavtkachuk@yahoo.com";
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };

    starship.enable = true;

    fzf.enable = true;
    zoxide.enable = true;
  };

  xdg.enable = true;
}
