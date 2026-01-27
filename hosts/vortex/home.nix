{ inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      user = "f";
    };
    users.f = {
      imports = [
        ../../modules/user/packages.nix
        ../../modules/user/programs/direnv.nix
        ../../modules/user/programs/fzf.nix
        ../../modules/user/programs/git.nix
        ../../modules/user/programs/nh.nix
        ../../modules/user/programs/starship.nix
        ../../modules/user/programs/zoxide.nix
        ../../modules/user/programs/zsh.nix
      ];

      home = {
        username = "f";
        homeDirectory = "/home/f";
        stateVersion = "25.05";
      };
    };
  };
}
