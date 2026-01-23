{ ... }: {
  imports = [
    ./audio.nix
    ./boot.nix
    ./configuration.nix
    ./desktop.nix
    ./locale.nix
    ./networking.nix
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./virtualization.nix
  ];
}