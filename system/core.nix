{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  # User Configuration
  users.users.f = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "docker"
      "libvirtd"
      "networkmanager"
      "wheel"
    ];
  };

  # Localization
  time.timeZone = "Europe/Copenhagen";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ru_RU.UTF-8/UTF-8"
    ];
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "dk";
    packages = [ pkgs.terminus_font ];
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    curl
    wget
  ];

  # Nix Configuration
  nix = {
    settings = {
      auto-optimise-store = true;
      download-buffer-size = 200000000;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      flake-registry = "";
      nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
      substituters = [ "https://cache.nixos.org/" ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
  };

  environment.etc."nix/inputs/nixpkgs".source = inputs.nixpkgs.outPath;
  nixpkgs.config.allowUnfree = true;

  # Security
  security.sudo.wheelNeedsPassword = true;

  # System Version
  system.stateVersion = "25.05";
}
