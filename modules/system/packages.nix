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
    nixfmt-rfc-style
    ripgrep
    unzip
    vim
    wget
  ];

  nixpkgs.config.allowUnfree = true;

}
