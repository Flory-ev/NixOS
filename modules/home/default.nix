{ inputs, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
    users.f = {
      imports = [
        ./packages.nix
        ./programs.nix
        ./plasma.nix
      ];
      home = {
        username = "f";
        homeDirectory = "/home/f";
        stateVersion = "25.05";
      };
    };
  };
}
