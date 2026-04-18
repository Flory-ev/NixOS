{ ... }:
{
  # --- Hardware ---
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
    graphics.enable32Bit = true;
  };
}
