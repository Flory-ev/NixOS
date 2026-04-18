{ ... }:
{
  # --- Services ---
  services = {
    resolved.enable = true;
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 10;
    };
    flatpak.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
  };
}
