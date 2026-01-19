{ config, lib, pkgs, ... }:

{
  boot = {
    kernelParams = [ "quiet" "splash" ];
    kernelPackages = pkgs.linuxPackages_latest;
    
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      systemd-boot = {
        configurationLimit = 10;
        editor = false;
        enable = true;
        timeout = 5;
      };
    };

    plymouth.enable = true;
  };
}
