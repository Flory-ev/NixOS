# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                         NixOS Configuration Center                         ║
# ║                                                                             ║
# ║  This file is your "Settings" panel - like Windows Settings or macOS       ║
# ║  System Preferences. Change values here to customize your entire system!   ║
# ║                                                                             ║
# ║  After making changes, run: nh os switch                                   ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │                           👤 USER IDENTITY                              │
  # │  Your personal information used across the system                       │
  # └─────────────────────────────────────────────────────────────────────────┘

  username = "f"; # Your login username
  fullName = "F"; # Your full name (shown in apps)
  email = "vladislavtkachuk@yahoo.com"; # Your email (used in Git, etc.)

  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │                         🖥️  SYSTEM SETTINGS                             │
  # │  Core system configuration - usually don't change these                 │
  # └─────────────────────────────────────────────────────────────────────────┘

  hostname = "vortex"; # Your computer's name on the network
  system = "x86_64-linux"; # System architecture (don't change)
  stateVersion = "25.05"; # NixOS version (don't change after install!)
  flakePath = "/home/f/nixos"; # Path to this config folder

  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │                        🖼️  DESKTOP ENVIRONMENT                          │
  # │  Choose which desktop(s) to install and use                             │
  # └─────────────────────────────────────────────────────────────────────────┘

  # Which desktop to show at login? Options: "plasma" or "cosmic"
  defaultSession = "plasma";

  # Enable/disable desktop environments (set to false to remove completely)
  enablePlasma = true; # KDE Plasma - traditional, feature-rich
  enableCosmic = true; # COSMIC - modern, written in Rust

  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │                        🌍 REGION & LANGUAGE                              │
  # │  Timezone, language, and keyboard settings                              │
  # └─────────────────────────────────────────────────────────────────────────┘

  # Find your timezone: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
  timezone = "Europe/Copenhagen";

  # Language/locale (formats dates, currency, etc.)
  # Common: "en_US.UTF-8", "en_GB.UTF-8", "de_DE.UTF-8", "ru_RU.UTF-8"
  locale = "en_US.UTF-8";

  # Keyboard configuration
  keyboard = {
    layout = "us,ru"; # Keyboard layouts (comma-separated)
    variant = "dvorak"; # Layout variant ("" for standard QWERTY)
    options = "grp:alt_shift_toggle"; # How to switch layouts (Alt+Shift)
  };

  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │                       📱 DEFAULT APPLICATIONS                           │
  # │  Your preferred apps for common tasks                                   │
  # └─────────────────────────────────────────────────────────────────────────┘

  defaultShell = "zsh"; # Shell: "zsh", "bash", or "fish"
  terminal = "kitty"; # Terminal: "kitty", "alacritty", "wezterm"
  editor = "vscodium"; # Editor: "vscodium", "vim", "neovim", "helix"
  browser = "chromium"; # Browser: "chromium", "firefox", "brave"

  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │                          📝 GIT SETTINGS                                │
  # │  Version control configuration                                          │
  # └─────────────────────────────────────────────────────────────────────────┘

  git = {
    defaultBranch = "main"; # Default branch name for new repos
    gpgSign = false; # Sign commits with GPG? (true/false)
    gpgKey = ""; # Your GPG key ID (if signing enabled)
  };

  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │                         🌐 NETWORK SETTINGS                             │
  # │  DNS servers and firewall configuration                                 │
  # └─────────────────────────────────────────────────────────────────────────┘

  dns = {
    # Popular DNS providers:
    #   Cloudflare: "1.1.1.1" / "1.0.0.1" (fast, privacy-focused)
    #   Google:     "8.8.8.8" / "8.8.4.4" (reliable)
    #   Quad9:      "9.9.9.9" / "149.112.112.112" (security-focused)
    primary = "1.1.1.1";
    secondary = "1.0.0.1";
  };

  firewall = {
    enable = true; # Enable firewall? (recommended: true)
    openPorts = [ 7777 ]; # Ports to open (for gaming, servers, etc.)
  };

  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │                         🚀 BOOT & STARTUP                               │
  # │  How your system boots up                                               │
  # └─────────────────────────────────────────────────────────────────────────┘

  boot = {
    silent = true; # Hide boot messages? (cleaner startup)
    plymouth = true; # Show boot splash animation?
    configLimit = 10; # How many boot entries to keep
  };

  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │                        🗑️  GARBAGE COLLECTION                           │
  # │  Automatic cleanup of old system generations                            │
  # └─────────────────────────────────────────────────────────────────────────┘

  gc = {
    automatic = true; # Auto-cleanup old generations?
    frequency = "weekly"; # How often: "daily", "weekly", "monthly"
    olderThan = "7d"; # Delete generations older than this
    keep = 3; # Always keep at least this many
  };

  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │                       🔧 HARDWARE FEATURES                              │
  # │  Toggle hardware support on/off (false = removes related packages)     │
  # └─────────────────────────────────────────────────────────────────────────┘

  hardware = {
    bluetooth = true; # Bluetooth support
    audio = true; # Audio (PipeWire) support
    virtualization = true; # VMs & containers (QEMU, virt-manager)
    printing = true; # Printer support (CUPS)
    opengl = true; # Graphics/GPU acceleration
  };

  # ┌─────────────────────────────────────────────────────────────────────────┐
  # │                         🎨 THEMING (Preview)                            │
  # │  Visual customization - for future expansion                            │
  # └─────────────────────────────────────────────────────────────────────────┘

  theme = {
    style = "dark"; # Color scheme: "dark" or "light"
    accentColor = "blue"; # Accent: "blue", "purple", "green", etc.
    font = {
      mono = "JetBrains Mono"; # Monospace font (code, terminal)
      sans = "Noto Sans"; # UI font
    };
  };
}
