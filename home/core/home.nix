{ inputs, ... }:
{
  home-manager.users.f = {
    imports = [
      ../../home/packages.nix
      ../../home/programs/direnv.nix
      ../../home/programs/fzf.nix
      ../../home/programs/git.nix
      ../../home/programs/nh.nix
      ../../home/programs/starship.nix
      ../../home/programs/zoxide.nix
      ../../home/programs/zsh.nix
    ];

    home = {
      username = "f";
      homeDirectory = "/home/f";
      stateVersion = "25.05";
    };
  };
}
