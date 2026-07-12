{ pkgs, ... }:
{
  # --- Services ---
  services = {
    desktopManager.plasma6.enable = true;
    resolved.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --cmd niri-session";
          user = "greeter";
        };
      };
    };
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

  # Add portals for niri compatibility
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  security.polkit.enable = true;
}
