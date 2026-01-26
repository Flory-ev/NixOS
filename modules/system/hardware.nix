{ pkgs, ... }:

{
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    sensor.iio.enable = true;
    enableRedistributableFirmware = true;
  };

  services.fstrim.enable = true;
}
