{ pkgs, ... }:
{
  # --- Home Manager ---
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.f = _: {
      home = {
        username = "f";
        homeDirectory = "/home/f";
        stateVersion = "25.05";
        packages = with pkgs; [
          antigravity
          bat
          eza
          fd
          fzf
          qbittorrent
          libreoffice
          reaper
          spotify
          sqlitebrowser
          termius
          telegram-desktop
          tor-browser
          tree
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
    };
  };
}
