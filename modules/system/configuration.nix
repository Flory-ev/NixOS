{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{

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

  environment = {
    systemPackages = with pkgs; [
      curl
      nixfmt
      wget
    ];

    etc."nix/inputs/nixpkgs".source = inputs.nixpkgs.outPath;
  };

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

  nixpkgs.config.allowUnfree = true;

  security.sudo.wheelNeedsPassword = true;

  system.stateVersion = "25.05";
}
