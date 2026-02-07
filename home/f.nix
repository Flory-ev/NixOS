{ config, pkgs, ... }:

{
  home = {
    username = "f";
    homeDirectory = "/home/f";
    stateVersion = "25.05";

    packages = with pkgs; [
      antigravity
      bat
      bitwarden-desktop
      chromium
      discord
      eza
      fd
      fzf
      lutris
      nixfmt
      qbittorrent
      reaper
      spotify
      telegram-desktop
      thunderbird
      tor-browser
      tree
      vlc
      vscodium
      zoxide
    ];
  };

  programs = {
    git = {
      enable = true;
      settings = {
        user.name = "F";
        user.email = "vladislavtkachuk@yahoo.com";
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
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

      shellAliases = {
        boot = "nh os boot";
        clean = "nh clean all";
        switch = "nh os switch";
      };
    };
  };
}
