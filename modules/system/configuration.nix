{ ... }:

{

  nix = {
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    settings = {
      auto-optimise-store = true;
      download-buffer-size = 200000000;
			experimental-features = [
        "flakes"
        "nix-command"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
