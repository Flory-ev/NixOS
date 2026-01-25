{
  config,
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    curl
    fd
    gparted
    nixfmt
    ripgrep
    unzip
    vim
    wget
  ];

}
