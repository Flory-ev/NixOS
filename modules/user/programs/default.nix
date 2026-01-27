{ pkgs, user, ... }:

{
  imports = [
    ./programs/direnv.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/nh.nix
    ./programs/starship.nix
    ./programs/zoxide.nix
    ./programs/zsh.nix
  ];
}
