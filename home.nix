{ config, pkgs, ... }:
{
  home = {
    username = "f";
    homeDirectory = "/home/f";
    sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/bitwarden-ssh-agent.sock";
    };
    stateVersion = "26.05";
    packages = with pkgs; [
      bitwarden-desktop
      dust
      qbittorrent
      reaper
      spotify
      telegram-desktop
      termius
      vital
      wineWow64Packages.staging
      winetricks
      yabridge
      yabridgectl
    ];
  };

  programs = {
    bat.enable = true;
    eza.enable = true;
    fd.enable = true;
    firefox.enable = true;
    fish.enable = true;
    git = {
      enable = true;
      settings = {
        user.name = "F";
        user.email = "vladislavtkachuk@yahoo.com";
      };
    };
    ripgrep.enable = true;
    ssh = {
      enable = true;
      extraConfig = ''
        Host *
          IdentityAgent ~/.bitwarden-ssh-agent.sock
      '';
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
    zoxide.enable = true;
  };
}
