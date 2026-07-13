{ pkgs, ... }:
{
  # --- Boot ---
  boot = {
    initrd.systemd.enable = true;
    kernel.sysctl = {
      "kernel.dmesg_restrict" = true;
      "kernel.kptr_restrict" = 2;
      "kernel.unprivileged_bpf_disabled" = 1;
    };
    kernelModules = [ "btusb" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "amd_pstate=active"
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 5;
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "max";
        configurationLimit = 10;
      };
    };
  };
  zramSwap.enable = true;

  # --- System ---
  time.timeZone = "Europe/Copenhagen";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
  ];
  console.keyMap = "us";
}
