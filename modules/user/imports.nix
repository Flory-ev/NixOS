{ ... }: {
  imports = [
    ./users.nix
    ./packages.nix
    ./programs.nix
    ./services.nix
  ];
}