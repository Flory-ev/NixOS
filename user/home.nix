{ config, lib, pkgs, ... }:

{
  home = {
    username = "f";
    homeDirectory = "/home/f";
    stateVersion = "25.05";
  };

  programs = {
    direnv = { enable = true; nix-direnv.enable = true; };
    fzf = { enable = true; enableZshIntegration = true; };
    git = { enable = true; settings.init.defaultBranch = "Main"; settings.user = { name = "F"; email = "vladislavtkachuk@yahoo.com"; }; };
    nh = { enable = true; clean = { enable = true; extraArgs = "--keep-since 4d --keep 3"; }; flake = "/home/f/nixos"; };		zoxide = { enable = true; enableZshIntegration = true; options = [ "--cmd cd" ]; };
    zsh = { enable = true; oh-my-zsh = { enable = true; plugins = [ "git" ]; theme = "robbyrussell"; }; shellAliases = { cat = "bat"; ll = "eza -lah --icons"; ls = "eza"; ns = "nix-shell"; };
    };
  };

}
