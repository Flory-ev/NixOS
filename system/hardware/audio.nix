# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  system/hardware/audio.nix - Audio Configuration (PipeWire)              ║
# ║                                                                             ║
# ║  PipeWire is the modern audio system for Linux.                           ║
# ║  It replaces PulseAudio and JACK with a single unified system.            ║
# ║                                                                             ║
# ║  Enable/disable in variables.nix: hardware.audio                           ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{ pkgs, variables, ... }:
{
  # ─────────────────────────────────────────────────────────────────────────────
  # PIPEWIRE
  # Modern audio/video routing for Linux
  # ─────────────────────────────────────────────────────────────────────────────

  services.pipewire = {
    enable = variables.hardware.audio;

    # ALSA support (for apps that use ALSA directly)
    alsa.enable = variables.hardware.audio;
    alsa.support32Bit = variables.hardware.audio; # 32-bit app support (games)

    # PulseAudio compatibility (most desktop apps use this)
    pulse.enable = variables.hardware.audio;

    # JACK support (for professional audio apps like REAPER)
    jack.enable = variables.hardware.audio;
  };
}
