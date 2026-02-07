# Vortex

![NixOS](https://img.shields.io/badge/NixOS-25.05-5277C3?logo=nixos)
![License](https://img.shields.io/badge/License-Unlicense-green)

A modern, declarative NixOS setup using Flakes with Home Manager integration.

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
nixos
├── flake.lock
├── flake.nix
├── hardware-configuration.nix
├── license.md
└── readme.md
```

This configuration uses a monolith approach - everything is contained in `flake.nix`

---

## Quick Start

### Installation

1. Install NixOS
2. Clone this repository:
   ```shell
   git clone https://github.com/IIFlory/Vortex.git ~/vortex
   cd ~/vortex
   ```
3. Generate hardware configuration:
   ```shell
   nixos-generate-config --root /mnt
   cp /mnt/etc/nixos/hardware-configuration.nix ~/vortex/
   ```
4. Install:
   ```shell
   sudo nixos-rebuild switch --flake .#vortex
   ```

### Post-Install Usage

| Command | Description |
|---------|-------------|
| `nh os switch` | Apply configuration changes |
| `nh os boot` | Apply on next boot only |
| `nh search <package>` | Search for packages |
| `nh clean all` | Clean old generations |

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

---

## Customization

### Adding Packages

Edit the `home.packages` list in `flake.nix`:

```nix
home.packages = with pkgs; [
  # Your 
  # packages
  # here
];
```

### Changing Desktop Environment

Replace the COSMIC services with your preferred DE:

```nix
# Example: KDE Plasma
services = {
   displayManager.sddm.enable = true;
   desktopManager.plasma6.enable = true;
}
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
nh os rollback
```