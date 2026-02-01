# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                         NixOS Configuration Center                         ║
# ║                                                                             ║
# ║  This file is your "Settings" panel - like Windows Settings or macOS       ║
# ║  System Preferences. Change values here to customize your entire system!   ║
# ║                                                                             ║
# ║  Quick Reference:                                                          ║
# ║    • User Identity     - Lines 30-50                                       ║
# ║    • System Settings   - Lines 52-70                                       ║
# ║    • Desktop/DE        - Lines 72-120                                      ║
# ║    • Region/Language   - Lines 122-155                                     ║
# ║    • Default Apps      - Lines 157-200                                     ║
# ║    • Development       - Lines 202-250                                     ║
# ║    • Network/Security  - Lines 252-310                                     ║
# ║    • Boot/Performance  - Lines 312-360                                     ║
# ║    • Hardware          - Lines 362-420                                     ║
# ║    • Gaming            - Lines 422-460                                     ║
# ║    • Theming           - Lines 462-520                                     ║
# ║    • Backup/Sync       - Lines 522-560                                     ║
# ║    • Advanced          - Lines 562+                                        ║
# ║                                                                             ║
# ║  After making changes, run: nh os switch                                   ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{
  # ============================================================================
  # 👤 USER IDENTITY
  # ============================================================================
  # Your personal information used across the system

  # Your login username (lowercase, no spaces)
  username = "f";

  # Your full name (displayed in applications)
  fullName = "F";

  # Your email address (used in Git, SSH keys, etc.)
  email = "vladislavtkachuk@yahoo.com";

  # Hashed password (generate with: mkpasswd -m sha-512)
  # Leave empty to set password interactively on first login
  hashedPassword = "";

  # SSH public keys for authorized access
  # Add your public keys here for passwordless SSH login
  sshAuthorizedKeys = [];

  # ============================================================================
  # 🖥️ SYSTEM SETTINGS
  # ============================================================================
  # Core system configuration

  # Your computer's network hostname
  hostname = "vortex";

  # System architecture
  # Options: "x86_64-linux", "aarch64-linux"
  system = "x86_64-linux";

  # NixOS state version - DO NOT CHANGE after installation!
  # This determines system compatibility
  stateVersion = "25.05";

  # Path to your flake configuration directory
  flakePath = "/home/f/nixos";

  # Windows dual-boot support
  # Set to true if you dual-boot with Windows (fixes clock issues)
  windowsDualBoot = false;

  # ============================================================================
  # 🖼️ DESKTOP ENVIRONMENT
  # ============================================================================
  # Choose your desktop environment and window manager

  # Primary desktop environment
  # Options: "plasma", "gnome", "cosmic", "hyprland", "none"
  desktopEnvironment = "plasma";

  # Default session at login (must match an enabled DE)
  defaultSession = "plasma";

  # Display manager theme
  # Options: "breeze", "elarun", "maldives", "mountain", "sugar-candy"
  displayManager = {
    theme = "breeze";
  };

  # Desktop wallpaper settings
  desktop = {
    wallpaper = {
      # Path to wallpaper image (leave empty for default)
      path = "";
      # Enable random wallpaper rotation
      random = false;
      # Rotation interval (in minutes)
      interval = 30;
    };
  };

  # Hyprland-specific settings (only used when desktopEnvironment = "hyprland")
  hyprland = {
    # Monitor configuration
    # Format: "name,resolution@refreshrate,position,scale"
    monitors = [
      "eDP-1,1920x1080@60,0x0,1"
      ",preferred,auto,1"  # Auto-detect additional monitors
    ];
  };

  # ============================================================================
  # 🌍 REGION & LANGUAGE
  # ============================================================================
  # Timezone, language, and input settings

  # Find your timezone: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
  timezone = "Europe/Copenhagen";

  # Primary locale (formats dates, numbers, currency)
  # Common: "en_US.UTF-8", "en_GB.UTF-8", "de_DE.UTF-8", "ru_RU.UTF-8"
  locale = "en_US.UTF-8";

  # Additional locales to generate
  supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
    "da_DK.UTF-8/UTF-8"
  ];

  # Keyboard configuration
  keyboard = {
    # Layout codes (comma-separated for multiple)
    # Common: "us", "gb", "de", "ru", "fr"
    layout = "us,ru";

    # Layout variant
    # Options: "", "dvorak", "colemak", "nodeadkeys", "mac"
    variant = "";

    # Layout switching options
    # Common: "grp:alt_shift_toggle", "grp:win_space_toggle", "grp:caps_toggle"
    options = "grp:alt_shift_toggle";
  };

  # Console (TTY) font settings
  console = {
    # Font package
    fontPackage = "terminus_font";
    # Font name
    font = "ter-v16n";
  };

  # ============================================================================
  # 📱 DEFAULT APPLICATIONS
  # ============================================================================
  # Your preferred apps for common tasks

  # Default shell
  # Options: "zsh", "bash", "fish"
  defaultShell = "zsh";

  # Shell configuration
  zsh = {
    # Oh-my-zsh theme
    # Popular: "robbyrussell", "powerlevel10k/powerlevel10k", "agnoster"
    theme = "robbyrussell";
    # Additional oh-my-zsh plugins
    extraPlugins = [ "zoxide" "fzf" ];
  };

  # Default terminal emulator
  # Options: "kitty", "alacritty", "wezterm", "foot", "ghostty"
  terminal = "kitty";

  # Terminal multiplexer preference
  # Options: "tmux", "zellij", "none"
  terminalMultiplexer = "tmux";

  # Default text editor
  # Options: "vscodium", "vscode", "neovim", "vim", "helix", "emacs"
  editor = "vscodium";

  # Default web browser
  # Options: "chromium", "firefox", "brave", "librewolf", "qutebrowser"
  browser = "chromium";

  # ============================================================================
  # 📝 DEVELOPMENT SETTINGS
  # ============================================================================
  # Version control and development tools

  git = {
    # Default branch name for new repositories
    defaultBranch = "main";

    # Sign commits with GPG
    gpgSign = false;

    # Your GPG key ID (if signing enabled)
    # Find with: gpg --list-secret-keys --keyid-format=long
    gpgKey = "";

    # Use rebase for pull operations
    pullRebase = true;
  };

  # GPG configuration
  gpg = {
    # SSH keys to use with gpg-agent
    sshKeys = [];
  };

  # ============================================================================
  # 🌐 NETWORK & SECURITY
  # ============================================================================
  # DNS, firewall, and security settings

  # DNS server configuration
  dns = {
    # Primary DNS server
    # Popular options:
    #   Cloudflare: "1.1.1.1" (fast, privacy-focused)
    #   Google:     "8.8.8.8" (reliable)
    #   Quad9:      "9.9.9.9" (security-focused)
    #   AdGuard:    "94.140.14.14" (ad-blocking)
    primary = "1.1.1.1";
    secondary = "1.0.0.1";
  };

  # Firewall configuration
  firewall = {
    # Enable the firewall (recommended)
    enable = true;
    # TCP ports to open
    openPorts = [ 7777 ];
    # UDP ports to open
    openUDPPorts = [];
    # Allow ping/ICMP
    allowPing = true;
    # Log refused connections
    logRefused = true;
  };

  # VPN configuration
  vpn = {
    wireguard = {
      enable = false;
    };
  };

  # Security hardening options
  security = {
    # Enable kernel hardening
    hardening = true;
    # Require password for sudo
    sudoNeedsPassword = true;
    # Enable AppArmor
    apparmor = false;
    # Harden SSH configuration
    sshHardening = false;
  };

  # ============================================================================
  # 🚀 BOOT & PERFORMANCE
  # ============================================================================
  # Boot configuration and system performance

  boot = {
    # Hide boot messages for cleaner startup
    silent = true;
    # Show Plymouth boot splash animation
    plymouth = true;
    # Plymouth theme
    plymouthTheme = "breeze";
    # Number of bootloader entries to keep
    configLimit = 10;
    # Boot menu timeout (in seconds, 0 to skip)
    timeout = 5;
    # Enable CPU vulnerability mitigations
    mitigations = true;
  };

  # Performance optimization
  performance = {
    # Enable ZRAM swap (compressed RAM swap)
    zram = true;
    # Enable Kernel Same-page Merging (memory deduplication)
    ksm = false;
  };

  # Garbage collection settings
  gc = {
    # Automatic cleanup of old generations
    automatic = true;
    # Cleanup frequency
    frequency = "weekly";
    # Delete generations older than
    olderThan = "7d";
    # Minimum generations to keep
    keep = 3;
  };

  # Nix settings
  nix = {
    # Binary cache substituters
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    # Trusted public keys for substituters
    trustedPublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    # Additional overlays
    overlays = [];
  };

  # ============================================================================
  # 🔧 HARDWARE FEATURES
  # ============================================================================
  # Toggle hardware support

  hardware = {
    # Bluetooth support
    bluetooth = true;

    # Audio support (PipeWire)
    audio = true;

    # Graphics/GPU acceleration
    graphics = true;
    # Enable video acceleration (VAAPI/VDPAU)
    videoAcceleration = true;

    # Printer support (CUPS)
    printing = true;

    # Scanner support
    scanning = false;

    # Virtualization support (QEMU/KVM)
    virtualization = true;
  };

  # Laptop-specific settings (auto-detected)
  laptop = {
    # Enable laptop optimizations (auto-detected from battery presence)
    enable = true;
  };

  # Container configuration
  containers = {
    # Docker support
    docker = false;
    # Docker storage driver
    dockerStorageDriver = "overlay2";
    # Start Docker on boot
    dockerAutoStart = false;

    # Podman support
    podman = false;
  };

  # ============================================================================
  # 🎮 GAMING
  # ============================================================================
  # Gaming and entertainment

  gaming = {
    # Enable gaming features
    enable = true;

    # Steam gaming platform
    steam = true;
    # Enable Gamescope session for Steam
    gamescope = false;

    # Lutris game launcher
    lutris = false;

    # Heroic Games Launcher (Epic/GOG)
    heroic = false;

    # Prism Launcher (Minecraft)
    prismLauncher = false;

    # MangoHud overlay
    mangohud = false;
  };

  # ============================================================================
  # 🎨 THEMING
  # ============================================================================
  # Visual customization

  theme = {
    # Color scheme style
    # Options: "dark", "light", "auto"
    style = "dark";

    # Accent color
    # Options: "blue", "purple", "green", "red", "orange", "pink", "teal"
    accentColor = "blue";

    # Font configuration
    font = {
      # Monospace font (terminal, code)
      # Options: "JetBrains Mono", "Fira Code", "Cascadia Code", "Hack"
      mono = "JetBrains Mono";

      # Sans-serif font (UI, interface)
      # Options: "Noto Sans", "Inter", "Roboto", "Ubuntu"
      sans = "Noto Sans";

      # Serif font (documents)
      # Options: "Noto Serif", "Libre Baskerville", "Merriweather"
      serif = "Noto Serif";

      # Font size (in points)
      size = 11;
    };
  };

  # ============================================================================
  # 💾 BACKUP & SYNC
  # ============================================================================
  # Backup and synchronization settings

  backup = {
    # Enable BorgBackup
    enable = false;
    # Paths to backup
    paths = [ "~/Documents" "~/Pictures" "~/.config" ];
    # Paths to exclude
    exclude = [ "*.tmp" "*.cache" "node_modules" "target" ];
    # Backup repository location
    repo = "";
    # Password file path
    passFile = "";
    # SSH key for remote backup
    sshKey = "";
    # Backup frequency (systemd timer format)
    frequency = "daily";
  };

  sync = {
    # Syncthing file synchronization
    syncthing = {
      enable = false;
      # Devices to sync with
      devices = {};
      # Folders to sync
      folders = {};
    };
  };

  # ============================================================================
  # 📬 NOTIFICATIONS
  # ============================================================================
  # Notification settings

  notifications = {
    email = {
      enable = false;
    };
  };

  # ============================================================================
  # 📦 APPLICATION SETTINGS
  # ============================================================================
  # Individual application toggles

  apps = {
    # Communication
    discord = true;
    telegram = true;
    slack = false;
    thunderbird = false;
    element = false;

    # Media
    vlc = true;
    mpv = false;
    spotify = true;
    obs = false;
    ffmpeg = false;

    # Image editing
    gimp = false;
    inkscape = false;
    krita = false;

    # Office
    libreoffice = true;

    # Utilities
    flameshot = true;
  };

  # ============================================================================
  # ✨ EXTRAS
  # ============================================================================
  # Fun and miscellaneous

  extras = {
    # Terminal audio visualizer
    cava = false;
    # Pipe screensaver
    pipes = false;
    # Matrix rain effect
    cmatrix = false;
    # ASCII aquarium
    asciiquarium = false;
  };

  # ============================================================================
  # 🔬 ADVANCED SETTINGS
  # ============================================================================
  # Advanced configuration (modify with caution)

  # Kernel parameters (appended to default)
  kernelParams = [];

  # Additional system packages
  extraSystemPackages = [];

  # Additional user packages
  extraUserPackages = [];

  # System-wide environment variables
  environmentVariables = {};

  # Custom systemd services
  systemdServices = {};
}
