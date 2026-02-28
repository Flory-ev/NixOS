{ pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages =
    (with pkgs; [
      curl
      nixfmt
      wget
    ])
    ++ (with pkgs-unstable; [
      depotdownloader
    ]);
}
