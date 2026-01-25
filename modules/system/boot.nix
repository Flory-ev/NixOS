{ pkgs, ... }:

{
  boot = {
    kernelParams = [
      "quiet"
      "splash"
    ];
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 10;
      };
    };

    plymouth.enable = true;
  };
}
