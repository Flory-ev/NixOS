{
  config,
  lib,
  pkgs,
  ...
}:

{
  services = {
    displayManager.cosmic-greeter.enable = true;
    
		desktopManager.cosmic.enable = true;

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

  programs = {
    firefox.enable = true;

    gamemode.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };

    appimage = {
      enable = true;
      binfmt = true;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
      ];
    };

    nh = {
      enable = true;
      flake = "/home/f/vortex";
      clean = {
        enable = true;
        extraArgs = "--keep 3 --keep-since 4d";
      };
    };
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
}
