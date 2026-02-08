{ pkgs, inputs, ... }:

{
  imports = [ inputs.stylix.homeManagerModules.stylix ];

  stylix = {
    enable = true;
    image = pkgs.nixos-artwork.wallpapers.nine-ish-dark-gray.gnome-dark;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sizes = {
        applications = 12;
        terminal = 14;
        desktop = 11;
        popups = 10;
      };
    };

    opacity = {
      applications = 0.9;
      terminal = 0.8;
      desktop = 0.95;
      popups = 0.85;
    };

    targets = {
      vscode.enable = false; # Handled manually in vscodium usually
      gnome.enable = true;
      gtk.enable = true;
    };
  };
}
