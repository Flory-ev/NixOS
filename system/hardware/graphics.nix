# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  system/hardware/graphics.nix - GPU & Graphics Configuration             ║
# ║                                                                             ║
# ║  Enables hardware graphics acceleration (OpenGL, Vulkan).                 ║
# ║  Required for games, video playback, and desktop effects.                 ║
# ║                                                                             ║
# ║  Enable/disable in variables.nix: hardware.opengl                          ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{ variables, ... }:
{
  # ─────────────────────────────────────────────────────────────────────────────
  # GRAPHICS / OPENGL
  # Hardware acceleration for graphics
  # ─────────────────────────────────────────────────────────────────────────────

  hardware.graphics = {
    enable = variables.hardware.opengl;
    enable32Bit = variables.hardware.opengl; # 32-bit support (for older games)
  };

  # ─────────────────────────────────────────────────────────────────────────────
  # NOTE: GPU-specific drivers
  #
  # For NVIDIA, add to your host config:
  #   services.xserver.videoDrivers = [ "nvidia" ];
  #   hardware.nvidia.modesetting.enable = true;
  #
  # For AMD, it usually works out of the box.
  #
  # For Intel, it usually works out of the box.
  # ─────────────────────────────────────────────────────────────────────────────
}
