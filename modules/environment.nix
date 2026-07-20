{ pkgs, ... }:
{
  coreutils.package = pkgs.uutils-coreutils;

  environment.systemPackages = with pkgs; [
    nixfmt
  ];

  environment.sessionVariables = {
    PROTON_ENABLE_NVAPI = "1";
    PROTON_HIDE_NVIDIA_GPU = "0";
    STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "0";
    WINE_FULLSCREEN_FSR = "1";
    WINE_FULLSCREEN_FSR_STRENGTH = "2";
  };
}
