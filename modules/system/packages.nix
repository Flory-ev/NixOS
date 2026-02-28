{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    curl
    nixfmt
    wget
  ];
}
