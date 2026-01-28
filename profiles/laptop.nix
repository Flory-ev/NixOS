{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./base.nix
    ../system/hardware/audio.nix
    ../system/hardware/graphics.nix
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    font-awesome
    jetbrains-mono
  ];

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      START_CHARGE_THRESH_BAT0 = 20;
      STOP_CHARGE_THRESH_BAT0 = 80;

      USB_AUTOSUSPEND = true;

      DISK_DEVICES = "nvme0n1 sda";
      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";

      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";
    };
  };

  services.thermald.enable = true;

  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = false;
      accelSpeed = "0.5";
      clickMethod = "clickfinger";
      tappingDragLock = false;
      scrollMethod = "twofinger";
    };
  };

  programs.light.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;

  services.fprintd.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.udisks2.enable = true;
  services.gvfs.enable = true;

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "suspend";

    extraConfig = ''
      HandlePowerKey=suspend
      IdleAction=suspend
      IdleActionSec=30min
    '';
  };

  hardware.enableRedistributableFirmware = true;

  services.fwupd.enable = true;

  services.fstrim.enable = true;

  boot.kernelParams = [ "nvme_core.default_ps_max_latency_us=0" ];
}
