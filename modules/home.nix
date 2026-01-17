{ config, lib, pkgs, ... }:

{
  home = {
    homeDirectory = "/home/f";
    packages = with pkgs; [ 
      bat 
      eza 
      fzf 
      zoxide 
    ];
    stateVersion = "25.05";
    username = "f";
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      settings = {
        init.defaultBranch = "Main";
        user.email = "vladislavtkachuk@yahoo.com";
        user.name = "F";
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };

    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };
      shellAliases = {
        cat = "bat";
        ll = "eza -lah --icons";
        ls = "eza";
        ns = "nix-shell";
      };
    };
  };
}