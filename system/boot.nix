{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot = {
    initrd = {
      systemd.enable = true;
      verbose = true;
    };

    kernel.sysctl = {
      "kernel.dmesg_restrict" = true;
      "kernel.kptr_restrict" = 2;
      "kernel.unprivileged_bpf_disabled" = 1;
    };

    kernelModules = [ "btusb" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "mitigations=auto"
      "quiet"
      "splash"
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

    plymouth = {
      enable = true;
      theme = "breeze";
    };

    tmp.cleanOnBoot = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
