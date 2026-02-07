# Vortex NixOS Configuration

A modern, declarative NixOS setup using Flakes with Home Manager integration. Built for daily driving, gaming, and development.

---

## Overview

| Attribute | Value |
|-----------|-------|
| **User** | `f` |
| **Hostname** | `vortex` |
| **Platform** | `x86_64-linux` |
| **State Version** | `25.05` |

---

## Structure

```
├── flake.lock
├── flake.nix
├── hardware-configuration.nix
├── license.md
└── readme.md
```

This configuration uses a **monolith** approach - everything is contained in `flake.nix`

---

## Features

### Desktop Environment
- **COSMIC Desktop** - System76's modern Rust-based desktop environment
- **Plymouth** boot splash with Breeze theme
- **Systemd-boot** with graphical editor disabled for security

### Gaming
- Steam with remote play firewall rules
- Gamemode for performance optimization
- Lutris for managing game launchers

### Development & Virtualization
- Docker & Podman container engines
- QEMU/KVM via libvirt (virt-manager included)
- nix-ld for running non-Nix binaries
- AppImage support

### Audio & Media
- PipeWire with PulseAudio and JACK compatibility
- WirePlumber session manager
- 32-bit ALSA support for legacy applications

### Security
- Kernel hardening (kptr_restrict, dmesg_restrict, BPF restrictions)
- Firewall with ping allowed, port 7777 open for gaming
- DNS-over-TLS with DNSSEC via systemd-resolved
- Sudo password required for wheel group

### Power Management
- TLP with performance/powersave governors
- Battery charge thresholds (75%-80%)
- ZRAM swap with zstd compression
- fstrim for SSD maintenance

---

## Flake Inputs

| Input | Purpose |
|-------|---------|
| `nixpkgs` | Main package repository (unstable channel) |
| `home-manager` | User environment management |
| `nh` | Nix helper for convenient rebuilds |

---

## Quick Start

### Initial Installation

1. Install NixOS from the minimal ISO
2. Generate hardware configuration:
   ```shell
   nixos-generate-config --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix ~/nixos/
   ```
3. Clone this repository:
   ```shell
   git clone https://github.com/IIFlory/NixOS-Configuration.git ~/nixos
   cd ~/nixos
   ```
4. Install:
   ```shell
   sudo nixos-install --flake .#vortex
   ```

### Post-Install Usage

| Command | Description |
|---------|-------------|
| `nh os switch` | Apply configuration changes |
| `nh os boot` | Apply on next boot only |
| `nh clean all` | Clean old generations (keeps 3, 4 days) |

---

## User Packages

### CLI Tools
- `bat` - Enhanced cat with syntax highlighting
- `eza` - Modern ls replacement
- `fd` - Fast file finder
- `fzf` - Fuzzy finder
- `tree` - Directory tree viewer
- `zoxide` - Smarter cd command

### GUI Applications
- `firefox` - Web browser
- `chromium` - Alternative browser
- `vscodium` - Code editor
- `discord` - Communication
- `telegram-desktop` - Messaging
- `thunderbird` - Email client
- `spotify` - Music streaming
- `vlc` - Media player
- `qbittorrent` - BitTorrent client
- `bitwarden-desktop` - Password manager
- `tor-browser` - Privacy browser
- `reaper` - Digital audio workstation

---

## Shell Configuration

Zsh with Oh-My-Zsh featuring:
- Syntax highlighting
- Auto-suggestions
- Git and sudo plugins
- Custom aliases for Nix operations

### Aliases
| Alias | Command |
|-------|---------|
| `switch` | `nh os switch` |
| `boot` | `nh os boot` |
| `clean` | `nh clean all` |

---

## Customization

### Adding Packages

Edit the `home.packages` list in `flake.nix`:

```nix
home.packages = with pkgs; [
  # Your packages here
  neovim
  ripgrep
];
```

### Changing Desktop Environment

Replace the COSMIC services with your preferred DE:

```nix
# Example: KDE Plasma
services.xserver.enable = true;
services.displayManager.sddm.enable = true;
services.desktopManager.plasma6.enable = true;
```

### User Configuration

Modify the `users.users.f` section to change:
- Username
- Shell
- Additional groups

---

## Maintenance

### Update System
```shell
nix flake update
nh os switch
```

### Garbage Collection
```shell
nh clean all              # Keep 3 generations, 4 days
nix store optimise        # Deduplicate store
```

### Rollback
```shell
sudo nixos-rebuild switch --rollback
```

---

## Troubleshooting

### Build Failures
```shell
# Check syntax
nix flake check

# Build without switching
nh os build

# Verbose build
nixos-rebuild switch --flake .#vortex --verbose
```

### Home Manager Issues
```shell
# Rebuild home only
home-manager switch --flake .#f

# Check home news
home-manager news
```
