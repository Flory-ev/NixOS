{ pkgs, ... }:

{
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };

    gamemode.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    zsh.enable = true;
  };
}
