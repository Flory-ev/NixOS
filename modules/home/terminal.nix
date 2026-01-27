{ pkgs, ... }:

{
  programs.kitty.enable = true;

  home.packages = with pkgs; [
    antigravity
    ncdu
    tree
  ];

  imports = [
    ./zsh.nix
    ./starship.nix
    ./fzf.nix
    ./zoxide.nix
    ./direnv.nix
    ./nh.nix
  ];
}
