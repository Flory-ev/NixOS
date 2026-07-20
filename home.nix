{ pkgs, ... }:
{
  home = {
    username = "f";
    homeDirectory = "/home/f";
    stateVersion = "25.05";

    packages = with pkgs; [
      qbittorrent
      spotify
      telegram-desktop
      termius
    ];
  };

  # Programs
  programs = {
    bat.enable = true;
    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };
    firefox.enable = true;
    fish.enable = true;
    gh.enable = true;
    git = {
      enable = true;
      settings = {
        user.name = "F";
        user.email = "vladislavtkachuk@yahoo.com";
      };
    };
    ripgrep.enable = true;
    zed-editor = {
      enable = true;
      extensions = [ "nix" ];
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
