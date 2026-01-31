{
  config,
  pkgs,
  variables,
  ...
}:
{
  imports = [
    ../software/packages.nix
    ../software/programs.nix
  ];

  home.stateVersion = variables.stateVersion;
}
