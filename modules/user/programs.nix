{ pkgs, user, ... }:

{
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
        init.defaultBranch = "main";
        user = {
          name = "F";
          email = "vladislavtkachuk@yahoo.com";
        };
      };
    };

    nh = {
      enable = true;
      flake = "/home/${user}/nixos";
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
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
      };
    };
  };
}
