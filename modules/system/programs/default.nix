{ pkgs, ... }:

{
  imports = [
    ./system-programs/appimage.nix
    ./system-programs/firefox.nix
    ./system-programs/gamemode.nix
    ./system-programs/steam.nix
    ./system-programs/zsh.nix
  ];
}
