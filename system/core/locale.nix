# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  system/core/locale.nix - Region & Language Settings                     ║
# ║                                                                             ║
# ║  Controls localization:                                                     ║
# ║  - Timezone                                                                 ║
# ║  - System language                                                          ║
# ║  - Keyboard layout                                                          ║
# ║                                                                             ║
# ║  All settings come from variables.nix                                       ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{ variables, ... }:
{
  # ─────────────────────────────────────────────────────────────────────────────
  # TIMEZONE
  # ─────────────────────────────────────────────────────────────────────────────

  time.timeZone = variables.timezone;

  # ─────────────────────────────────────────────────────────────────────────────
  # LANGUAGE & LOCALE
  # ─────────────────────────────────────────────────────────────────────────────

  i18n = {
    # Primary system language
    defaultLocale = variables.locale;

    # Locale settings for specific categories
    # These control date/time formats, currency, paper size, etc.
    extraLocaleSettings = {
      LC_ADDRESS = variables.locale;
      LC_IDENTIFICATION = variables.locale;
      LC_MEASUREMENT = variables.locale;
      LC_MONETARY = variables.locale;
      LC_NAME = variables.locale;
      LC_NUMERIC = variables.locale;
      LC_PAPER = variables.locale;
      LC_TELEPHONE = variables.locale;
      LC_TIME = variables.locale;
    };
  };

  # ─────────────────────────────────────────────────────────────────────────────
  # KEYBOARD LAYOUT
  # ─────────────────────────────────────────────────────────────────────────────

  # X11/Wayland keyboard settings (from variables.nix)
  services.xserver.xkb = {
    layout = variables.keyboard.layout; # e.g., "us,ru"
    variant = variables.keyboard.variant; # e.g., "dvorak"
    options = variables.keyboard.options; # e.g., "grp:alt_shift_toggle"
  };
}
