{ pkgs, ... }:

{
  # Bluetooth support
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # SSD TRIM support
  services.fstrim.enable = true;

  # Sensor monitoring
  hardware.sensor.iio.enable = true;

  # Firmware support
  hardware.enableRedistributableFirmware = true;
}
