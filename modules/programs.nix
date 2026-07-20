{ pkgs, ... }:
{
  programs = {
    appimage = {
      enable = true;
      binfmt = true;
    };
    fish.enable = true;
    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = -10;
          softrealtime = "auto";
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          nv_powermizer_mode = 1;
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations activated'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations deactivated'";
        };
      };
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    nh = {
      enable = true;
      flake = "/home/f/nixos";
      clean = {
        enable = true;
        extraArgs = "--keep 3 --keep-since 4d";
      };
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
      ];
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
    };
  };
}
