{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    btop
    curl
    direnv
    eza
    fastfetch
    fd
    fzf
    gh
    gparted
    lazygit
    nixfmt
    ripgrep
    tldr
    unzip
    vim
    wget
    zoxide
  ];
}
