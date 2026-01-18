{ config, lib, pkgs, ... }:

{
  boot.kernelParams = [ "quiet" "splash" ];

  boot.loader = {
    efi = { canTouchEfiVariables = true; efiSysMountPoint = "/boot";
    };

    systemd-boot = { configurationLimit = 10; editor = false; enable = true;
    };
    timeout = 5;

  boot.plymouth.enable = true;
	
	kernelPackages = pkgs.linuxPackages_latest;

}
