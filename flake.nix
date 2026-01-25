{
  description = "NixOS";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      mkSystem =
        host: user: system:
        let
          lib = nixpkgs.lib;
          importModules =
            dir: excludes:
            let
              contents = builtins.readDir dir;
              nixFiles = lib.filterAttrs (
                name: type:
                type == "regular"
                && lib.hasSuffix ".nix" name
                && !(builtins.elem name (
                  [
                    "imports.nix"
                    "default.nix"
                    "home.nix"
                  ]
                  ++ excludes
                ))
              ) contents;
            in
            map (name: dir + "/${name}") (builtins.attrNames nixFiles);
        in
        lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs user; };
          modules =
            (importModules ./modules/system [ ])
            ++ (importModules ./modules/user [
              "packages.nix"
              "programs.nix"
              "home.nix"
            ])
            ++ [
              ./hosts/${host}/default.nix
              ./hosts/${host}/hardware.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = { inherit inputs user; };
                  users.${user} = import ./modules/user/home.nix;
                };
              }
            ];
        };
    in
    {
      nixosConfigurations = {
        vortex = mkSystem "vortex" "f" "x86_64-linux";
      };
    };
}
