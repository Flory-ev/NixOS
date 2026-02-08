{ pkgs, ... }:

{
  programs = {
    firefox.enable = true;
    gamemode.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };

    appimage = {
      enable = true;
      binfmt = true;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
      ];
    };

    nh = {
      enable = true;
      flake = "/home/f/vortex";
      clean = {
        enable = true;
        extraArgs = "--keep 3 --keep-since 4d";
      };
    };
  };
}
