{ inputs, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.f = {
      imports = [
        ./niri.nix
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
