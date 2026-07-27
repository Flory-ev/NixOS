{ pkgs, ... }:
{
  home = {
    username = "f";
    homeDirectory = "/home/f";
    stateVersion = "26.05";

    packages = with pkgs; [
      qbittorrent
      spotify
      telegram-desktop
      termius
    ];
  };

  programs = {
    firefox.enable = true;

    fish.enable = true;

    gh.enable = true;

    git = {
      enable = true;
      userName = "F";
      userEmail = "vladislavtkachuk@yahoo.com";
    };

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };
        git_branch = {
          symbol = "🌱 ";
        };
      };
    };

    zed-editor = {
      enable = true;
      extensions = [ "nix" ];
    };
  };
}
