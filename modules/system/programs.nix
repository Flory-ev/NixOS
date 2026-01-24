{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{

  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    gamemode.enable = true;
    steam.enable = true;
    zsh.enable = true;
  };

}
