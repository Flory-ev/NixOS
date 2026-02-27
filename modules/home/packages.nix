{ pkgs, ... }:

{
  home.packages =
    (with pkgs; [
      antigravity
      bat
      eza
      fd
      fzf
      qbittorrent
      thunderbird
      tor-browser
      tree
      vlc
      zoxide
    ])
    ++ (with pkgs-unstable; [
      bitwarden-desktop
      chromium
      discord
      lutris
      nixfmt
      reaper
      spotify
      telegram-desktop
      veloren
      vscodium
    ]);
}
