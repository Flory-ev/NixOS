{ config, pkgs, ... }:
{
  imports = [
    ../software/packages.nix
    ../software/programs.nix
  ];

  home.stateVersion = "25.05";

  xdg.configFile."gtk-3.0/gtk.css".force = true;
  xdg.configFile."gtk-4.0/gtk.css".force = true;
}
