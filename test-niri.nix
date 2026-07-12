{ pkgs ? import <nixpkgs> {} }:
let
  hm = import (fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz") { inherit pkgs; };
in
  builtins.hasAttr "niri" hm.options.programs
