{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bitwarden-desktop
    discord
    telegram-desktop
    thunderbird
  ];
}
