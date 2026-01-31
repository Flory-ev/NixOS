# NixOS Configuration

[![NixOS](https://img.shields.io/badge/NixOS-25.05-blue?logo=nixos&logoColor=white)](https://nixos.org)
[![Flake](https://img.shields.io/badge/Flake-Enabled-green?logo=nixos)](https://wiki.nixos.org/wiki/Flakes)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> A modular, reproducible, and declarative NixOS configuration with support for multiple machine profiles.

---

## 📑 Table of Contents

- [Features](#-features)
- [Quick Start](#-quick-start)
- [System Overview](#-system-overview)
- [Project Structure](#-project-structure)
- [Current Setup](#%EF%B8%8F-current-setup)
- [Installation](#-installation)
- [Customization](#-customization)
- [Common Tasks](#-common-tasks)
- [Profiles](#-profiles)
- [Troubleshooting](#-troubleshooting)
- [Resources](#-resources)

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🏗️ **Flake-Based** | Fully reproducible builds with locked dependencies |
| 📦 **Modular Design** | Clean separation of concerns across hosts, profiles, and modules |
| 🖥️ **Multi-Host** | Single configuration for multiple machines |
| 🔋 **Laptop Optimized** | Power management, battery care, and thermal controls |
| 🏠 **Home Manager** | Declarative user environment management |
| ⚡ **Auto-Cleanup** | Automatic garbage collection and store optimization |
| 🔐 **Security Hardened** | Firewall, DNSSEC, and fingerprint authentication |

---

## 🚀 Quick Start

### Prerequisites

- NixOS installed with Flakes enabled
- Git

### Initial Setup

```bash
# Clone the repository
git clone https://github.com/IIFlory/NixOS-Configuration.git ~/nixos
cd ~/nixos

# Rebuild the system (replace 'vortex' with your hostname)
sudo nixos-rebuild switch --flake .#vortex
```

### Daily Operations

```bash
# Update flake inputs and rebuild
nix flake update && sudo nixos-rebuild switch --flake .#vortex

# Or use nh (faster, configured in this flake)
nh os switch

# Clean up old generations
nh clean all
```

---

## 📁 Project Structure

```
.
├── 📄 flake.nix                    # Flake entry point & inputs
├── 🔒 flake.lock                   # Locked dependency versions
├── ⚙️ variables.nix                # Central configuration (edit this!)
│
├── 🖥️ hosts/                       # Host-specific configurations
│   └── vortex/
│       ├── default.nix             # Host configuration
│       └── hardware-configuration.nix  # Hardware scan
│
├── 👤 profiles/                    # Machine profiles (reusable)
│   ├── base.nix                    # Base config (all machines)
│   ├── desktop.nix                 # Desktop workstation profile
│   └── laptop.nix                  # Laptop profile (power management)

│
├── ⚙️ system/                      # System-level NixOS modules
│   ├── core/                       # Essential system settings
│   │   ├── boot.nix                # Bootloader & kernel params
│   │   ├── locale.nix              # Timezone & localization
│   │   ├── security.nix            # Security & authentication
│   │   └── settings.nix            # Nix daemon & flake settings
│   │
│   ├── hardware/                   # Hardware support
│   │   ├── audio.nix               # PipeWire audio stack
│   │   ├── bluetooth.nix           # Bluetooth support
│   │   ├── graphics.nix            # GPU drivers & Mesa
│   │   ├── networking.nix          # NetworkManager & firewall
│   │   └── virtualization.nix      # QEMU/KVM & libvirt
│   │
│   └── software/                   # System software
│       ├── packages.nix            # System-wide packages
│       ├── programs.nix            # Program configurations
│       └── services.nix            # System services
│
└── 🏠 home/                        # Home Manager configuration
    ├── core/
    │   ├── home.nix                # Home Manager entry
    │   └── users.nix               # User definitions

    ├── desktop/                    # Desktop environment & theming
    │   ├── desktop.nix             # COSMIC + Plasma 6 DE
    │   └── stylix.nix              # Stylix theming (colors, fonts, cursors)
    │
    └── software/
        ├── packages.nix            # User packages
        └── programs.nix            # User programs
```

---

## 🖥️ Current Setup

### Host Information

|          |     |
|----------|-----|
| **User** | `f` |
| **Hostname** | `vortex` |
| **Profile** | Laptop |
| **Desktop Environment** | COSMIC |
| **Display Manager** | COSMIC Greeter |
| **Shell** | Zsh |

### Key Features

#### 🔋 Power Management
- **TLP** – Advanced power management with battery care
- **Battery Thresholds** – 20-80% charging for longevity
- **Thermald** – Thermal management
- **Zram** – 50% memory compression
- **Earlyoom** – OOM protection

#### 🖱️ Input
- Natural scrolling & tap-to-click
- Clickfinger touchpad behavior
- Fingerprint reader authentication

#### 🔧 System
- **Virtualization** – libvirt + virt-manager (QEMU/KVM)
- **Auto-cleanup** – Weekly Nix store optimization
- **Generations** – Keep last 3, 4+ days old

---

## 📦 Installation

### Fresh NixOS Install

1. **Install NixOS** using the graphical or minimal ISO

2. **Enable Flakes** (if not already):
   ```shell
   sudo nix-shell -p nixFlakes
   ```

3. **Clone this repository**:
   ```shell
   git clone https://github.com/IIFlory/NixOS-Configuration.git ~/nixos
   cd ~/nixos
   ```

4. **Generate hardware config** (for new hosts):
   ```shell
   sudo nixos-generate-config --show-hardware-config > hosts/$(hostname)/hardware-configuration.nix
   ```

5. **Build and switch**:
   ```shell
   sudo nixos-rebuild switch --flake .#$(hostname)
   ```

### Adding to Existing NixOS

```shell
# Backup existing config
sudo mv /etc/nixos /etc/nixos.backup

# Clone and link
sudo ln -s ~/nixos /etc/nixos

# Rebuild
sudo nixos-rebuild switch --flake ~/nixos#vortex
```

---

## 🎨 Customization

### ⚙️ Central Configuration (`variables.nix`)

**This is the main file to edit!** All common settings are centralized here:

```nix
{
  # User Configuration
  username = "f";
  fullName = "F";
  email = "vladislavtkachuk@yahoo.com";

  # System Configuration
  hostname = "vortex";
  system = "x86_64-linux";
  stateVersion = "25.05";

  # Locale & Regional Settings
  timezone = "Europe/Copenhagen";
  locale = "en_US.UTF-8";

  # Keyboard configuration
  keyboard = {
    layout = "us,ru";
    variant = "dvorak";
    options = "grp:alt_shift_toggle";
  };

  # Desktop Configuration
  defaultSession = "plasma";  # or "cosmic"

  # Git Configuration
  git = {
    defaultBranch = "main";
  };

  # Paths
  flakePath = "/home/f/nixos";
}
```

Simply edit `variables.nix` and rebuild to apply changes across the entire system.

### 🖥️ Desktop Environment

The default session is set in `variables.nix`:

```nix
defaultSession = "plasma";  # or "cosmic"
```

To enable/disable desktop environments, edit `home/desktop/desktop.nix`:

```nix
services.desktopManager.plasma6.enable = true;
services.desktopManager.cosmic.enable = true;
```

### 🔋 Adjust Battery Thresholds

Edit `profiles/laptop.nix`:

```nix
services.tlp.settings = {
  START_CHARGE_THRESH_BAT0 = 20;  # Start charging at 20%
  STOP_CHARGE_THRESH_BAT0 = 80;   # Stop charging at 80%
};
```

### ➕ Adding Packages

**System-wide** (all users): `system/software/packages.nix`

```nix
environment.systemPackages = with pkgs; [
  neofetch
  htop
  vim
];
```

**User-specific**: `home/software/packages.nix`

```nix
home.packages = with pkgs; [
  firefox
  discord
];
```

---

## 🔧 Common Tasks

### ➕ Add a New Host

1. **Create host directory**:
   ```bash
   mkdir -p hosts/newhost
   ```

2. **Generate hardware config**:
   ```bash
   nixos-generate-config --show-hardware-config > hosts/newhost/hardware-configuration.nix
   ```

3. **Create `hosts/newhost/default.nix`**:
   ```nix
   { config, pkgs, ... }:
   {
     imports = [
       ./hardware-configuration.nix
       ../../profiles/laptop.nix  # or desktop.nix
     ];
     
     networking.hostName = "newhost";
     
     # Host-specific overrides
     # ...
   }
   ```

4. **Add to `flake.nix`**:
   ```nix
   nixosConfigurations.newhost = nixpkgs.lib.nixosSystem {
     system = "x86_64-linux";
     specialArgs = { inherit inputs; };
     modules = [
       ./hosts/newhost
       home-manager.nixosModules.home-manager
       # ... other modules
     ];
   };
   ```

### 🔌 Enable a Service

```nix
# In any .nix file
services.myservice = {
  enable = true;
  settings = {
    # configuration
  };
};
```

### 🔄 Update System

```bash
# Update all flake inputs
nix flake update

# Rebuild with updates
sudo nixos-rebuild switch --flake .#vortex

# Or combined
nix flake update && sudo nixos-rebuild switch --flake .#vortex
```

### 🗑️ Garbage Collection

```bash
# Manual cleanup
sudo nix-collect-garbage -d

# With nh (recommended - keeps last 3 generations, 4+ days)
nh clean all

# Clean and optimize store
sudo nix store optimise
```

---

## 🛠️ Profiles

### Base Profile (`profiles/base.nix`)

Core configuration imported by all machines:

| Component | Configuration |
|-----------|---------------|
| Boot | systemd-boot, latest kernel |
| Locale | EN/US, UTC timezone |
| Security | Firewall, sudo wheel group |
| Network | NetworkManager, Cloudflare DNS |
| Nix | Flakes enabled, auto-optimise |

### Laptop Profile (`profiles/laptop.nix`)

Extends base with portable optimizations:

| Feature | Implementation |
|---------|----------------|
| Power | TLP, thermald |
| Battery | 20-80% charge limits |
| Touchpad | libinput with gestures |
| Storage | NVMe optimization |
| Memory | Zram swap (50%) |
| Protection | earlyoom |

### Desktop Profile (`profiles/desktop.nix`)

Extends base for stationary workstations:

| Feature | Implementation |
|---------|----------------|
| Graphics | Full GPU support |
| Storage | Disks service |
| Power | Minimal management |

---

## 🔐 Security Features

| Feature | Status | Configuration |
|---------|--------|---------------|
| Firewall | ✅ Enabled | `networking.firewall.enable = true` |
| DNS | ✅ Secure | Cloudflare DNS with DNSSEC |
| Authentication | ✅ Multi | Password + Fingerprint |
| Sudo | ✅ Restricted | Wheel group only |
| Sessions | ✅ Protected | Auto-lock on suspend |

---

## 📝 Notes

- **Flake location**: `/home/f/nixos` (configured for `nh`)
- **Auto-optimization**: Weekly
- **Boot entries**: Limited to 10 most recent
- **Garbage collection**: Automatic via `nh`

---

## 📄 License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.