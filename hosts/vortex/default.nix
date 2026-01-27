{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/desktop.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  networking.hostName = "vortex";

  users.users.f = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      user = "f";
    };
    users.f = {
      imports = [
        ../../modules/home/terminal.nix
        ../../modules/home/browsers.nix
        ../../modules/home/communications.nix
        ../../modules/home/media.nix
        ../../modules/home/gaming.nix
        ../../modules/home/editors.nix
        ../../modules/home/git.nix
      ];

      home.username = "f";
      home.homeDirectory = "/home/f";
      home.stateVersion = "25.05";
    };
  };
}
