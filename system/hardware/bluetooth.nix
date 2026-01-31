# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  system/hardware/bluetooth.nix - Bluetooth Configuration                 ║
# ║                                                                             ║
# ║  Enable/disable in variables.nix: hardware.bluetooth                       ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{ variables, ... }:
{
  # ─────────────────────────────────────────────────────────────────────────────
  # BLUETOOTH
  # For wireless headphones, keyboards, mice, etc.
  # ─────────────────────────────────────────────────────────────────────────────

  hardware.bluetooth = {
    enable = variables.hardware.bluetooth;
    powerOnBoot = variables.hardware.bluetooth; # Turn on at boot

    settings = {
      General = {
        # Enable all Bluetooth profiles
        Enable = "Source,Sink,Media,Socket";

        # Enable experimental features (better codec support)
        Experimental = true;
      };
    };
  };
}
