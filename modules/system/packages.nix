{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    curl
    fd
    kdePackages.partitionmanager
    nixfmt
    ripgrep
    unzip
    vim
    wget
  ];

  nixpkgs.config.allowUnfree = true;

}
