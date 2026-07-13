{ pkgs, ... }:
{
  # --- Services ---
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    resolved.enable = true;
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

  security.polkit.enable = true;
}
