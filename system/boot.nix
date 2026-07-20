{ ... }:
{
  boot = {
    initrd.systemd.enable = true;
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
      "vm.swappiness" = 10;
      "kernel.dmesg_restrict" = true;
      "kernel.kptr_restrict" = 2;
      "kernel.unprivileged_bpf_disabled" = 1;
    };
    kernelParams = [
      "quiet"
      "amd_pstate=active"
      "nvidia-drm.fbdev=1"
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 5;
      systemd-boot = {
        configurationLimit = 10;
        consoleMode = "max";
        editor = false;
        enable = true;
      };
    };
  };
}
