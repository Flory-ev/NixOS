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

  boot.kernelParams = [ "nvme_core.default_ps_max_latency_us=0" ];

	programs.light.enable = true;

	zramSwap = {
	  enable = true;
	  memoryPercent = 50;
	};

  services = {
		logind = {
      lidSwitch = "suspend";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "suspend";

      extraConfig = ''
        HandlePowerKey=suspend
        LockSessions=yes
				IdleAction=suspend
        IdleActionSec=30min
      '';
    };

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        START_CHARGE_THRESH_BAT0 = 20;
        STOP_CHARGE_THRESH_BAT0 = 80;

        USB_AUTOSUSPEND = 1;
        USB_EXCLUDE_AUDIO = 1;

        DISK_DEVICES = "nvme0n1 sda";
        DISK_APM_LEVEL_ON_AC = "254 254";
        DISK_APM_LEVEL_ON_BAT = "128 128";

        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";

        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";
      };
    };

    libinput = {
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

		earlyoom = {
      enable = true;
      freeMemThreshold = 5;
    };
		
		fprintd.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    udisks2.enable = true;
  };

	fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    font-awesome
    jetbrains-mono
  ];
}
