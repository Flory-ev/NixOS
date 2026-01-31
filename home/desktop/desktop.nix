# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  home/desktop/desktop.nix - Desktop Environment Configuration            ║
# ║                                                                             ║
# ║  Configures your desktop environment(s) - KDE Plasma and/or COSMIC.       ║
# ║  Enable/disable them in variables.nix                                      ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  lib,
  pkgs,
  variables,
  ...
}:
{
  # ─────────────────────────────────────────────────────────────────────────────
  # EXCLUDED PACKAGES
  # Remove default apps you don't want (uncomment to exclude)
  # ─────────────────────────────────────────────────────────────────────────────

  environment = lib.mkMerge [
    # COSMIC exclusions (only apply if COSMIC is enabled)
    (lib.mkIf variables.enableCosmic {
      cosmic.excludePackages = with pkgs; [
        # cosmic-edit               # COSMIC text editor
        # cosmic-files              # COSMIC file manager
        # cosmic-term               # COSMIC terminal
      ];
    })

    # Plasma exclusions (only apply if Plasma is enabled)
    (lib.mkIf variables.enablePlasma {
      plasma6.excludePackages = with pkgs.kdePackages; [
        # konsole                   # KDE terminal
        # dolphin                   # KDE file manager
        # kate                      # KDE text editor
        # elisa                     # KDE music player
      ];
    })
  ];

  # ─────────────────────────────────────────────────────────────────────────────
  # DESKTOP SERVICES
  # ─────────────────────────────────────────────────────────────────────────────

  services = {
    # Display Manager (login screen)
    displayManager = {
      # Use COSMIC greeter if COSMIC is enabled, otherwise SDDM (Plasma's default)
      cosmic-greeter.enable = variables.enableCosmic;
      sddm.enable = variables.enablePlasma && !variables.enableCosmic;

      # Default session at login (from variables.nix)
      defaultSession = variables.defaultSession;
    };

    # Desktop Environments
    desktopManager = {
      cosmic.enable = variables.enableCosmic; # COSMIC Desktop
      plasma6.enable = variables.enablePlasma; # KDE Plasma 6
    };
  };
}
