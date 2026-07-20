{ pkgs, ... }:
{
  programs = {
    bat.enable = true;
    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };
  };
  ripgrep.enable = true;
  starship = {
    enable = true;
    enableFishIntegration = true;
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
  zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
