{ inputs, ... }:
{
  home-manager.users.f = {
    imports = [
      ../../modules/home/packages.nix
      ../../modules/home/programs/direnv.nix
      ../../modules/home/programs/fzf.nix
      ../../modules/home/programs/git.nix
      ../../modules/home/programs/nh.nix
      ../../modules/home/programs/starship.nix
      ../../modules/home/programs/zoxide.nix
      ../../modules/home/programs/zsh.nix
    ];

    home = {
      username = "f";
      homeDirectory = "/home/f";
      stateVersion = "24.05";
    };
  };
}