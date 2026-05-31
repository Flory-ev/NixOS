{ inputs, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.f = {
      imports = [
        ./packages.nix
        ./programs.nix
      ];
      home = {
        username = "f";
        homeDirectory = "/home/f";
        stateVersion = "25.05";
      };
    };
  };
}
