{ config, lib, pkgs, ... }:

{
  home.username = "f";
  home.homedirectory = "/home/f";

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "fzf" "zoxide" ];
    };
    shellAliases = {
      ll = "eza -lah";
      ls = "eza";
      cat = "bat";
      cd = "z";
      ns = "nix-shell";
    };
    initContent = ''
      eval "$(zoxide init zsh)"
    '';
  };

  programs.git = {
    enable = true;
    settings.user.name = "F";
    settings.user.email = "vladislavtkachuk@yahoo.com";
    settings = {
      init.defaultBranch = "Main";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.stateVersion = "25.05";
}
