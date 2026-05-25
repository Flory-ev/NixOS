{ pkgs, ... }:
{
  # --- Gaming ---

  # CS2 and other Steam games require a high max_map_count
  boot.kernel.sysctl."vm.max_map_count" = 2147483642;

  # CPU performance governor for gaming sessions
  powerManagement.cpuFreqGovernor = "performance";

  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam.gamescopeSession.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud      # FPS/perf overlay  (launch CS2 with MANGOHUD=1)
    protonup-qt   # manage Proton-GE versions
  ];

  # Faster wineserver / CS2 shader compilation
  environment.sessionVariables = {
    WINE_FULLSCREEN_FSR = "1";
    PROTON_ENABLE_NVAPI = "1";
    PROTON_HIDE_NVIDIA_GPU = "0";
  };
}
