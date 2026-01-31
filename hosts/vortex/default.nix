# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  hosts/vortex/default.nix - Host-Specific Configuration                   ║
# ║                                                                             ║
# ║  This file is for settings unique to THIS specific computer.              ║
# ║  Each computer should have its own folder in hosts/                        ║
# ║                                                                             ║
# ║  Things that go here:                                                       ║
# ║  - Hardware-specific tweaks                                                 ║
# ║  - This machine's hostname                                                  ║
# ║  - Profile selection (laptop, desktop, server)                             ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  config,
  pkgs,
  inputs,
  variables,
  ...
}:
{
  imports = [
    # Auto-generated hardware config (from nixos-generate-config)
    ./hardware-configuration.nix

    # Use the laptop profile (includes base + audio + graphics)
    # Change to ../../profiles/desktop.nix for a desktop PC
    ../../profiles/laptop.nix
  ];

  # ─────────────────────────────────────────────────────────────────────────────
  # This computer's network hostname (from variables.nix)
  # ─────────────────────────────────────────────────────────────────────────────
  networking.hostName = variables.hostname;
}
