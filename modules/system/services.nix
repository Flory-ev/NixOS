{ pkgs, lib, ... }:

{
  services = {
    flatpak.enable = true;

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };

    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        disableWhileTyping = false;
      };
    };

    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 10;
    };

    fstrim.enable = true;
    fwupd.enable = true;
    logrotate.enable = true;
    smartd.enable = true;
    thermald.enable = true;
    power-profiles-daemon.enable = lib.mkForce false;

    locate = {
      enable = true;
      package = pkgs.plocate;
      interval = "daily";
    };
  };
}
