{ ... }: {
  imports = [
    ./boot.nix
    ./configuration.nix
    ./desktop.nix
    ./locale.nix
    ./networking.nix
    ./virtualization.nix
  ];
}