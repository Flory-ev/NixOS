{
  config,
  inputs ? { },
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    consoleLogLevel = 3;

    initrd.systemd.enable = true;

    kernel.sysctl = {
      "kernel.dmesg_restrict" = true;
      "kernel.kptr_restrict" = 2;
      "kernel.unprivileged_bpf_disabled" = 1;
    };

    kernelModules = [ "btusb" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "mitigations=auto" ];

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

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };

    enableRedistributableFirmware = true;
    firmware = [ pkgs.linux-firmware ];

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    ksm.enable = true;
  };

  networking = {
    hostName = "vortex";
    wireguard.enable = false;

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 7777 ];
      allowedUDPPorts = [ 7777 ];
      logRefusedConnections = false;
    };

    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = false;
      };
    };
  };

  time.timeZone = "Europe/Copenhagen";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  console = {
    font = "Lat2-Terminus16";
    packages = [ pkgs.terminus_font ];
  };

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      fira-code
      font-awesome
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };


  programs.zsh = {
    enable = true;
    
  };

  services = {
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;

    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        disableWhileTyping = false;
      };
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
    };

    flatpak.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    logrotate.enable = true;
    smartd.enable = true;
    thermald.enable = true;

    locate = {
      enable = true;
      package = pkgs.plocate;
      interval = "daily";
    };

    resolved = {
      enable = true;
      settings.Resolve = {
        DNSSEC = "true";
      };
    };
  };

  users.users.f = {
    isNormalUser = true;
    description = "f";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}