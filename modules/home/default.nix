{ inputs, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.f = {
      imports = [
        ./git.nix
        ./niri.nix
        ./packages.nix
        ./shell.nix
      ];
      home = {
        username = "f";
        homeDirectory = "/home/f";
        stateVersion = "25.05";
      };
    };
  };
}
