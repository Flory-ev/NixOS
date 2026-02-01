# NixOS Configuration

<div align="center">

![NixOS](https://img.shields.io/badge/NixOS-5277C3?logo=nixos&logoColor=white&style=for-the-badge)
![Home Manager](https://img.shields.io/badge/Home%20Manager-5277C3?logo=nixos&logoColor=white&style=for-the-badge)
![Flakes](https://img.shields.io/badge/Flakes-Enabled-5277C3?style=for-the-badge)

**A clean, modular, and beginner-friendly NixOS configuration with centralized settings.**

[Quick Start](#quick-start) • [Configuration](#configuration) • [Documentation](#documentation) • [Troubleshooting](#troubleshooting)

</div>

---

## ✨ Features

- 🎯 **Centralized Configuration** - All settings in one file (`variables.nix`)
- 🏗️ **Modular Structure** - Easy to understand and extend
- 🔄 **Flake-based** - Reproducible and version-locked
- 🏠 **Home Manager Integration** - Dotfiles and user programs managed declaratively
- 💻 **Multi-Host Support** - Easy to add new computers
- 🎨 **Multiple Desktop Environments** - Plasma, GNOME, COSMIC, Hyprland
- 🔧 **Sensible Defaults** - Works out of the box
- 📚 **Well Documented** - Every option explained

---

## 🚀 Quick Start

### Prerequisites

- NixOS installed on your system
- Basic familiarity with the command line

### First Time Setup

1. **Clone this repository:**

   ```bash
   git clone https://github.com/yourusername/nixos-config.git ~/nixos
   cd ~/nixos
   ```

2. **Edit your settings in `variables.nix`:**

   ```bash
   nano variables.nix  # or use your preferred editor
   ```

3. **Apply the configuration:**

   ```bash
   nh os switch
   ```

### Daily Usage

| Task | Command |
|------|---------|
| Apply changes after editing config | `nh os switch` |
| Update all packages | `nh os switch --update` |
| Build without applying | `nh os build` |
| Clean old generations | `nh clean all` |
| Show system info | `fastfetch` |

---

## 📁 Configuration

### File Structure

```
nixos/
├── 📄 flake.nix                    # Entry point - system composition
├── 📄 variables.nix                # 🎯 YOUR SETTINGS - edit this!
│
├── 📁 hosts/                       # Per-machine configurations
│   └── 📁 vortex/                  # Host "vortex" configuration
│       ├── 📄 default.nix          # Host-specific imports
│       └── 📄 hardware-configuration.nix  # Auto-generated hardware config
│
├── 📁 profiles/                    # Shared system profiles
│   ├── 📄 base.nix                 # Common to all systems
│   ├── 📄 laptop.nix               # Laptop optimizations
│   └── 📄 desktop.nix              # Desktop-specific settings
│
├── 📁 home/                        # Home Manager configurations
│   ├── 📁 core/
│   │   ├── 📄 home.nix             # Home Manager entry point
│   │   └── 📄 users.nix            # User account definitions
│   ├── 📁 desktop/
│   │   └── 📄 desktop.nix          # Desktop environment setup
│   └── 📁 software/
│       ├── 📄 packages.nix         # User applications
│       └── 📄 programs.nix         # Program configurations
│
└── 📁 system/                      # System-wide configuration
    ├── 📁 core/
    │   ├── 📄 boot.nix             # Boot loader, kernel, initrd
    │   ├── 📄 locale.nix           # Language, timezone, keyboard
    │   ├── 📄 security.nix         # Sudo, permissions, security
    │   └── 📄 settings.nix         # Nix settings, GC, optimisations
    ├── 📁 hardware/
    │   ├── 📄 audio.nix            # PipeWire configuration
    │   ├── 📄 bluetooth.nix        # Bluetooth support
    │   ├── 📄 graphics.nix         # GPU, OpenGL, drivers
    │   ├── 📄 networking.nix       # Network, WiFi, firewall, DNS
    │   └── 📄 virtualization.nix   # VMs, containers, QEMU
    └── 📁 software/
        ├── 📄 packages.nix         # System CLI tools
        ├── 📄 programs.nix         # System programs
        └── 📄 services.nix         # Background services
```

---

## 🎛️ Variables Reference

All your settings are controlled through `variables.nix`. Here's a complete reference:

### 👤 User Identity

| Variable | Description | Example |
|----------|-------------|---------|
| `username` | Login username | `"f"` |
| `fullName` | Display name in apps | `"John Doe"` |
| `email` | Used for Git, SSH keys | `"john@example.com"` |
| `hashedPassword` | Password hash (optional) | `"$6$rounds=5000$..."` |
| `sshAuthorizedKeys` | SSH public keys | `[ "ssh-ed25519 AAA..." ]` |

> 💡 **Tip:** Generate password hash with: `mkpasswd -m sha-512`

### 🖥️ System Settings

| Variable | Description | Example |
|----------|-------------|---------|
| `hostname` | Network name of your computer | `"vortex"` |
| `system` | CPU architecture | `"x86_64-linux"` |
| `stateVersion` | NixOS compatibility version | `"25.05"` |
| `flakePath` | Path to this configuration | `"/home/f/nixos"` |

### 🖼️ Desktop Environment

| Variable | Description | Options |
|----------|-------------|---------|
| `desktopEnvironment` | Primary DE to install | `"plasma"`, `"gnome"`, `"cosmic"`, `"hyprland"`, `"none"` |
| `defaultSession` | Session at login | Same as above |
| `displayManager.theme` | Login screen theme | `"breeze"`, `"elarun"`, `"sugar-candy"` |

**Hyprland-specific:**

| Variable | Description | Example |
|----------|-------------|---------|
| `hyprland.monitors` | Monitor configuration | `[ "eDP-1,1920x1080@60,0x0,1" ]` |

### 🌍 Region & Language

| Variable | Description | Example |
|----------|-------------|---------|
| `timezone` | Your timezone | `"Europe/Copenhagen"` |
| `locale` | System language | `"en_US.UTF-8"` |
| `supportedLocales` | Additional locales | `[ "en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" ]` |

**Keyboard:**

| Variable | Description | Example |
|----------|-------------|---------|
| `keyboard.layout` | Layout codes | `"us,ru"` |
| `keyboard.variant` | Layout variant | `"dvorak"`, `"colemak"`, `""` |
| `keyboard.options` | Switch method | `"grp:alt_shift_toggle"` |

> 📍 Find your timezone: [Wikipedia TZ Database](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

### 📱 Default Applications

| Variable | Description | Options |
|----------|-------------|---------|
| `defaultShell` | Command shell | `"zsh"`, `"bash"`, `"fish"` |
| `terminal` | Terminal emulator | `"kitty"`, `"alacritty"`, `"wezterm"`, `"ghostty"` |
| `editor` | Code editor | `"vscodium"`, `"vscode"`, `"neovim"`, `"helix"`, `"emacs"` |
| `browser` | Web browser | `"chromium"`, `"firefox"`, `"brave"`, `"librewolf"` |
| `terminalMultiplexer` | Terminal multiplexer | `"tmux"`, `"zellij"`, `"none"` |

**Zsh configuration:**

| Variable | Description | Example |
|----------|-------------|---------|
| `zsh.theme` | Oh-my-zsh theme | `"robbyrussell"`, `"powerlevel10k/powerlevel10k"` |
| `zsh.extraPlugins` | Additional plugins | `[ "zoxide" "fzf" ]` |

### 📝 Development

| Variable | Description | Example |
|----------|-------------|---------|
| `git.defaultBranch` | Default Git branch | `"main"` |
| `git.gpgSign` | Sign commits with GPG | `false` |
| `git.gpgKey` | GPG key ID | `"A1B2C3D4"` |
| `git.pullRebase` | Rebase on pull | `true` |

### 🌐 Network & Security

**DNS:**

| Variable | Description | Popular Options |
|----------|-------------|-----------------|
| `dns.primary` | Primary DNS server | `"1.1.1.1"` (Cloudflare) |
| `dns.secondary` | Backup DNS server | `"1.0.0.1"` (Cloudflare) |

> Other options: Google `"8.8.8.8"`, Quad9 `"9.9.9.9"`, AdGuard `"94.140.14.14"`

**Firewall:**

| Variable | Description | Example |
|----------|-------------|---------|
| `firewall.enable` | Enable firewall | `true` |
| `firewall.openPorts` | Open TCP ports | `[ 7777 25565 ]` |
| `firewall.openUDPPorts` | Open UDP ports | `[ 51820 ]` |
| `firewall.allowPing` | Allow ICMP ping | `true` |

**Security:**

| Variable | Description | Default |
|----------|-------------|---------|
| `security.hardening` | Kernel hardening | `true` |
| `security.sudoNeedsPassword` | Password for sudo | `true` |
| `security.apparmor` | AppArmor MAC | `false` |
| `security.sshHardening` | Hardened SSH config | `false` |

**VPN:**

| Variable | Description | Default |
|----------|-------------|---------|
| `vpn.wireguard.enable` | WireGuard VPN | `false` |

### 🚀 Boot & Performance

**Boot:**

| Variable | Description | Default |
|----------|-------------|---------|
| `boot.silent` | Hide boot messages | `true` |
| `boot.plymouth` | Boot splash screen | `true` |
| `boot.plymouthTheme` | Splash theme | `"breeze"` |
| `boot.configLimit` | Boot entries to keep | `10` |
| `boot.timeout` | Boot menu timeout | `5` |
| `boot.mitigations` | CPU vulnerability patches | `true` |

**Performance:**

| Variable | Description | Default |
|----------|-------------|---------|
| `performance.zram` | Compressed RAM swap | `true` |
| `performance.ksm` | Memory deduplication | `false` |

**Garbage Collection:**

| Variable | Description | Example |
|----------|-------------|---------|
| `gc.automatic` | Auto-cleanup | `true` |
| `gc.frequency` | How often | `"weekly"` |
| `gc.olderThan` | Delete older than | `"7d"` |
| `gc.keep` | Minimum to keep | `3` |

**Nix Settings:**

| Variable | Description |
|----------|-------------|
| `nix.substituters` | Binary cache URLs |
| `nix.trustedPublicKeys` | Cache signing keys |
| `nix.overlays` | Custom package overlays |

### 🔧 Hardware Features

| Variable | Description | Default |
|----------|-------------|---------|
| `hardware.bluetooth` | Bluetooth support | `true` |
| `hardware.audio` | PipeWire audio | `true` |
| `hardware.graphics` | GPU acceleration | `true` |
| `hardware.videoAcceleration` | VAAPI/VDPAU | `true` |
| `hardware.printing` | CUPS printing | `true` |
| `hardware.scanning` | SANE scanning | `false` |
| `hardware.virtualization` | QEMU/KVM VMs | `true` |

**Laptop:**

| Variable | Description | Default |
|----------|-------------|---------|
| `laptop.enable` | Laptop optimizations | `true` (auto) |

**Containers:**

| Variable | Description | Default |
|----------|-------------|---------|
| `containers.docker` | Docker support | `false` |
| `containers.dockerStorageDriver` | Storage driver | `"overlay2"` |
| `containers.dockerAutoStart` | Start on boot | `false` |
| `containers.podman` | Podman support | `false` |

### 🎮 Gaming

| Variable | Description | Default |
|----------|-------------|---------|
| `gaming.enable` | Gaming features | `true` |
| `gaming.steam` | Steam platform | `true` |
| `gaming.gamescope` | Steam Big Picture | `false` |
| `gaming.lutris` | Lutris launcher | `false` |
| `gaming.heroic` | Epic/GOG games | `false` |
| `gaming.prismLauncher` | Minecraft | `false` |
| `gaming.mangohud` | Performance overlay | `false` |

### 🎨 Theming

| Variable | Description | Options |
|----------|-------------|---------|
| `theme.style` | Color scheme | `"dark"`, `"light"`, `"auto"` |
| `theme.accentColor` | Accent color | `"blue"`, `"purple"`, `"green"`, etc. |

**Fonts:**

| Variable | Description | Example |
|----------|-------------|---------|
| `theme.font.mono` | Monospace font | `"JetBrains Mono"` |
| `theme.font.sans` | UI font | `"Noto Sans"` |
| `theme.font.serif` | Document font | `"Noto Serif"` |
| `theme.font.size` | Base font size | `11` |

**Wallpaper:**

| Variable | Description | Example |
|----------|-------------|---------|
| `desktop.wallpaper.path` | Wallpaper file | `"~/Pictures/wallpaper.jpg"` |
| `desktop.wallpaper.random` | Random rotation | `false` |
| `desktop.wallpaper.interval` | Rotation interval (min) | `30` |

### 💾 Backup & Sync

**BorgBackup:**

| Variable | Description | Example |
|----------|-------------|---------|
| `backup.enable` | Enable backups | `false` |
| `backup.paths` | Paths to backup | `[ "~/Documents" "~/Pictures" ]` |
| `backup.exclude` | Patterns to exclude | `[ "*.tmp" "node_modules" ]` |
| `backup.repo` | Repository location | `"user@backup-server:repo"` |
| `backup.frequency` | Backup schedule | `"daily"` |

**Syncthing:**

| Variable | Description | Default |
|----------|-------------|---------|
| `sync.syncthing.enable` | Enable Syncthing | `false` |
| `sync.syncthing.devices` | Peer devices | `{}` |
| `sync.syncthing.folders` | Shared folders | `{}` |

### 📦 Applications

| Variable | Description | Default |
|----------|-------------|---------|
| `apps.discord` | Discord chat | `true` |
| `apps.telegram` | Telegram | `true` |
| `apps.slack` | Slack | `false` |
| `apps.thunderbird` | Email client | `false` |
| `apps.element` | Matrix client | `false` |
| `apps.vlc` | VLC media player | `true` |
| `apps.mpv` | mpv player | `false` |
| `apps.spotify` | Spotify | `true` |
| `apps.obs` | OBS Studio | `false` |
| `apps.gimp` | GIMP | `false` |
| `apps.inkscape` | Inkscape | `false` |
| `apps.libreoffice` | LibreOffice | `true` |
| `apps.flameshot` | Screenshots | `true` |

### ✨ Extras

| Variable | Description | Default |
|----------|-------------|---------|
| `extras.cava` | Audio visualizer | `false` |
| `extras.pipes` | Pipe screensaver | `false` |
| `extras.cmatrix` | Matrix rain | `false` |
| `extras.asciiquarium` | ASCII aquarium | `false` |

---

## 🔧 Common Tasks

### Add a New Package

**GUI application for your user:**

Edit `home/software/packages.nix`:

```nix
home.packages = with pkgs; [
  # ... existing packages
  firefox
  thunderbird
  obsidian
];
```

**CLI tool system-wide:**

Edit `system/software/packages.nix`:

```nix
environment.systemPackages = with pkgs; [
  # ... existing packages
  htop
  ripgrep
  fd
];
```

### Add a New Computer

1. **Create host directory:**

   ```bash
   mkdir -p hosts/newhost
   ```

2. **Create `hosts/newhost/default.nix`:**

   ```nix
   { variables, ... }:
   {
     imports = [
       ./hardware-configuration.nix
       ../../profiles/laptop.nix  # or desktop.nix
     ];
     
     # Host-specific settings
     networking.hostName = variables.hostname;
   }
   ```

3. **Generate hardware configuration:**

   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/newhost/hardware-configuration.nix
   ```

4. **Update `flake.nix` to include the new host:**

   ```nix
   nixosConfigurations.newhost = nixpkgs.lib.nixosSystem {
     specialArgs = { inherit inputs variables; };
     modules = [ ./hosts/newhost ];
   };
   ```

5. **Set hostname in `variables.nix`:**

   ```nix
   hostname = "newhost";
   ```

### Switch Desktop Environments

**To switch to COSMIC:**

```nix
# variables.nix
desktopEnvironment = "cosmic";
defaultSession = "cosmic";
enablePlasma = false;
enableCosmic = true;
```

**To switch to Hyprland:**

```nix
# variables.nix
desktopEnvironment = "hyprland";
defaultSession = "hyprland";
enablePlasma = false;
```

### Enable Gaming

```nix
# variables.nix
gaming = {
  enable = true;
  steam = true;
  gamescope = true;      # For Steam Big Picture
  lutris = true;         # For non-Steam games
  mangohud = true;       # Performance overlay
};
```

### Set Up Backups

```nix
# variables.nix
backup = {
  enable = true;
  paths = [ "~/Documents" "~/Pictures" "~/.config" ];
  exclude = [ "*.tmp" "node_modules" "target" ];
  repo = "user@backup-server:/backups/$(hostname)";
  passFile = "/home/f/.backup-pass";
  sshKey = "/home/f/.ssh/backup";
  frequency = "daily";
};
```

---

## 📚 Documentation

### Useful Commands

| Command | Description |
|---------|-------------|
| `nh os switch` | Apply configuration changes |
| `nh os switch --update` | Update packages and apply |
| `nh os build` | Build without applying |
| `nh clean all` | Remove old generations |
| `nix flake update` | Update flake inputs |
| `nix search nixpkgs <package>` | Search for packages |
| `nix-shell -p <package>` | Temporarily use a package |
| `fastfetch` | Show system information |
| `btop` | System resource monitor |

### Nix Expression Language Basics

```nix
# Strings
name = "John"
greeting = "Hello, ${name}!"  # Interpolation

# Lists
numbers = [ 1 2 3 4 5 ]

# Attribute sets (objects)
person = {
  name = "John";
  age = 30;
};

# Conditionals
enableFeature = if condition then true else false;

# Functions
add = a: b: a + b;
result = add 2 3;  # 5
```

### Finding Options

- **NixOS Options:** https://search.nixos.org/options
- **Home Manager Options:** https://nix-community.github.io/home-manager/options.html
- **Nix Packages:** https://search.nixos.org/packages

---

## 🐛 Troubleshooting

### Build Failures

**Problem:** `error: undefined variable 'xyz'`

**Solution:** The package name might be different. Search for it:

```bash
nix search nixpkgs xyz
```

**Problem:** `error: syntax error, unexpected ...`

**Solution:** Check for missing semicolons `;` or mismatched brackets in your edits.

### Boot Issues

**Problem:** System won't boot after changes

**Solution:** 
1. Boot from previous generation in bootloader
2. Fix the issue in your config
3. Rebuild: `nh os switch`

### Home Manager Issues

**Problem:** `home-manager switch` fails

**Solution:** Try rebuilding the whole system instead:

```bash
nh os switch
```

### Network Issues

**Problem:** No internet after changes

**Solution:** Check DNS settings in `variables.nix`:

```nix
dns = {
  primary = "1.1.1.1";    # Try different DNS
  secondary = "8.8.8.8";
};
```

### Getting Help

- [NixOS Discourse](https://discourse.nixos.org/)
- [NixOS Wiki](https://nixos.wiki/)
- [NixOS Matrix](https://matrix.to/#/#nix:nixos.org)
- [r/NixOS](https://reddit.com/r/NixOS)

---

## 📄 License

This configuration is provided as-is for educational purposes. Feel free to use, modify, and distribute.

---

<div align="center">

**Made with ❄️ Nix**

</div>
