{ pkgs, ... }:
{
  # --- Services ---
  services = {
    resolved.enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
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

  # Add gtk portal for file pickers in non-COSMIC sessions
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  security.polkit.enable = true;
}
