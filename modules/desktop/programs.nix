{ pkgs, ... }:
{
  # --- Programs ---
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    firefox.enable = true;
    kdeconnect.enable = true;
    niri.enable = true;
    nh = {
      enable = true;
      flake = "/home/f/nixos";
      clean = {
        enable = true;
        extraArgs = "--keep 3 --keep-since 4d";
      };
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
      ];
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
    virt-manager.enable = true;
    zsh.enable = true;
  };
}
