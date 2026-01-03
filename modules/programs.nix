{ config, lib, pkgs, ... }:

{
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

    programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/f/nixos";
  };

  programs.steam.enable = true;
  programs.zsh.enable = true;
}
