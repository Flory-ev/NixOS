{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./backups.nix
    ./locale.nix
    ./packages.nix
    ./security.nix
  ];

  environment.etc."nix/inputs/nixpkgs".source = inputs.nixpkgs.outPath;

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

  system.stateVersion = "25.05";
}
