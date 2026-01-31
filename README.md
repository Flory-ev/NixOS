# 🌀 NixOS Configuration

A clean, modular, and **beginner-friendly** NixOS configuration with a centralized settings file.

## 🚀 Quick Start

### Apply Changes
After editing any configuration file:
```bash
nh os switch
```

### Most Common Edits

**All your settings are in one place: `variables.nix`**

| Want to... | Edit this in `variables.nix` |
|------------|------------------------------|
| Change your name/email | `fullName`, `email` |
| Switch timezone | `timezone` |
| Change keyboard layout | `keyboard.layout`, `keyboard.variant` |
| Switch default browser | `browser` |
| Switch code editor | `editor` |
| Switch terminal | `terminal` |
| Change DNS servers | `dns.primary`, `dns.secondary` |
| Enable/disable Bluetooth | `hardware.bluetooth` |
| Enable/disable Printing | `hardware.printing` |
| Enable/disable VMs | `hardware.virtualization` |
| Switch desktop (Plasma/COSMIC) | `defaultSession`, `enablePlasma`, `enableCosmic` |

---

## 📁 File Structure

```
nixos/
├── variables.nix           # 🎛️  YOUR SETTINGS - edit this!
├── flake.nix               # Entry point (rarely edit)
│
├── hosts/
│   └── vortex/             # This computer's config
│       ├── default.nix     # Host-specific settings
│       └── hardware-configuration.nix  # Auto-generated
│
├── profiles/
│   ├── base.nix            # Shared by all systems
│   ├── laptop.nix          # Laptop-specific (battery, touchpad)
│   └── desktop.nix         # Desktop-specific
│
├── home/                   # User configuration (Home Manager)
│   ├── core/
│   │   ├── home.nix        # Home Manager entry point
│   │   └── users.nix       # User account settings
│   ├── desktop/
│   │   └── desktop.nix     # Desktop environment config
│   └── software/
│       ├── packages.nix    # GUI apps you use
│       └── programs.nix    # Configured apps (git, zsh, etc.)
│
└── system/                 # System-wide configuration
    ├── core/
    │   ├── boot.nix        # Boot loader, kernel
    │   ├── locale.nix      # Language, timezone
    │   ├── security.nix    # Sudo, permissions
    │   └── settings.nix    # Nix settings, garbage collection
    ├── hardware/
    │   ├── audio.nix       # PipeWire audio
    │   ├── bluetooth.nix   # Bluetooth support
    │   ├── graphics.nix    # GPU/OpenGL
    │   ├── networking.nix  # WiFi, firewall, DNS
    │   └── virtualization.nix  # VMs, QEMU
    └── software/
        ├── packages.nix    # CLI tools
        ├── programs.nix    # System programs (Steam, etc.)
        └── services.nix    # Background services
```

---

## 🎛️ Variables Reference

### 👤 User Identity
| Variable | Description | Example |
|----------|-------------|---------|
| `username` | Login username | `"f"` |
| `fullName` | Your full name | `"John Doe"` |
| `email` | Email address | `"john@example.com"` |

### 🖥️ System
| Variable | Description | Example |
|----------|-------------|---------|
| `hostname` | Computer name | `"vortex"` |
| `stateVersion` | NixOS version (don't change!) | `"25.05"` |
| `flakePath` | Path to this config | `"/home/f/nixos"` |

### 🖼️ Desktop
| Variable | Description | Options |
|----------|-------------|---------|
| `defaultSession` | Desktop at login | `"plasma"`, `"cosmic"` |
| `enablePlasma` | Install KDE Plasma | `true`/`false` |
| `enableCosmic` | Install COSMIC | `true`/`false` |

### 🌍 Region
| Variable | Description | Example |
|----------|-------------|---------|
| `timezone` | Your timezone | `"Europe/Copenhagen"` |
| `locale` | System language | `"en_US.UTF-8"` |
| `keyboard.layout` | Keyboard layouts | `"us,ru"` |
| `keyboard.variant` | Layout variant | `"dvorak"` or `""` |
| `keyboard.options` | Switch method | `"grp:alt_shift_toggle"` |

### 📱 Default Apps
| Variable | Description | Options |
|----------|-------------|---------|
| `defaultShell` | Command shell | `"zsh"`, `"bash"`, `"fish"` |
| `terminal` | Terminal emulator | `"kitty"`, `"alacritty"`, `"wezterm"` |
| `editor` | Code editor | `"vscodium"`, `"neovim"`, `"helix"` |
| `browser` | Web browser | `"chromium"`, `"firefox"`, `"brave"` |

### 🌐 Network
| Variable | Description | Example |
|----------|-------------|---------|
| `dns.primary` | Primary DNS | `"1.1.1.1"` (Cloudflare) |
| `dns.secondary` | Backup DNS | `"1.0.0.1"` |
| `firewall.enable` | Enable firewall | `true`/`false` |
| `firewall.openPorts` | Ports to open | `[ 7777 22 ]` |

### 🔧 Hardware Toggles
| Variable | Description | Default |
|----------|-------------|---------|
| `hardware.bluetooth` | Bluetooth support | `true` |
| `hardware.audio` | Audio (PipeWire) | `true` |
| `hardware.virtualization` | VMs (QEMU) | `true` |
| `hardware.printing` | Printer support | `true` |
| `hardware.opengl` | GPU acceleration | `true` |

### 🗑️ Garbage Collection
| Variable | Description | Example |
|----------|-------------|---------|
| `gc.automatic` | Auto-cleanup | `true` |
| `gc.frequency` | How often | `"weekly"` |
| `gc.olderThan` | Delete older than | `"7d"` |
| `gc.keep` | Minimum to keep | `3` |

---

## 🛠️ Common Tasks

### Add a New Package

**GUI app for your user:**
Edit `home/software/packages.nix`, add to the list.

**CLI tool system-wide:**
Edit `system/software/packages.nix`, add to the list.

### Add a New Computer

1. Create `hosts/newhost/default.nix`:
   ```nix
   { variables, ... }:
   {
     imports = [
       ./hardware-configuration.nix
       ../../profiles/laptop.nix  # or desktop.nix
     ];
     networking.hostName = variables.hostname;
   }
   ```

2. Generate hardware config:
   ```bash
   sudo nixos-generate-config --show-hardware-config > hosts/newhost/hardware-configuration.nix
   ```

3. Update `variables.nix`:
   ```nix
   hostname = "newhost";
   ```

### Switch Between Desktops

In `variables.nix`:
```nix
defaultSession = "cosmic";  # or "plasma"
```

To use only one desktop:
```nix
enablePlasma = false;
enableCosmic = true;
```

---

## 📚 Useful Commands

| Command | Description |
|---------|-------------|
| `nh os switch` | Apply configuration changes |
| `nh os build` | Build without applying |
| `nh clean all` | Remove old generations |
| `nix flake update` | Update all packages |
| `fastfetch` | Show system info |
| `btop` | System monitor |

---

## 🔗 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Package Search](https://search.nixos.org/packages)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [NixOS Wiki](https://nixos.wiki/)

---

*Happy Nixing! 🎉*