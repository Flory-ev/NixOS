{ user, ... }:

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

    home = {
      enable = true;
    };

    nh = {
      enable = true;
      flake = "/home/${user}/nixos";
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
        ];
      };
    };
  };
}
