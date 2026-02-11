# Vortex - NixOS Configuration

A modern, modular NixOS configuration using flakes, Home Manager, and the COSMIC desktop environment. This configuration provides a complete desktop environment with virtualization support, gaming features, and theming via Stylix.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration Structure](#configuration-structure)
- [Key Features](#key-features)
- [Modules](#modules)
- [Customization](#customization)
- [Maintenance](#maintenance)
- [Troubleshooting](#troubleshooting)

## Overview

**Vortex** is a declarative NixOS configuration designed for a polished desktop experience with minimal manual maintenance. It leverages the power of Nix flakes for reproducible system configurations and Home Manager for user-level package management.

- **Base System**: NixOS unstable (nixos-unstable channel)
- **Desktop Environment**: System76 COSMIC
- **Package Manager**: Home Manager
- **Theme**: Stylix with Tokyo Night dark color scheme
- **Shell**: Zsh with Oh-My-Zsh

## Prerequisites

Before using this configuration, ensure you have:

1. A working NixOS installation (stateVersion 25.05)
2. At least 30GB of free disk space
3. An internet connection
4. Access to the `/etc/nix/inputs/nixpkgs` path (configured for flake compatibility)
5. For virtualization features: hardware virtualization support (AMD-V/Intel-VT)

### Required Nix Configuration

Ensure your `/etc/nix/nix.conf` includes:

```nix
experimental-features = nix-command flakes
```

## Installation

### 1. Clone and Enter the Repository

```bash
# Clone this repository
git clone https://github.com/yourusername/vortex ~/.config/nixos
cd ~/.config/nixos

# If starting fresh on a new NixOS installation
# First, generate the initial hardware configuration:
nix-shell -p nixos-install-tools --command "nixos-generate-config --root /mnt"
```

### 2. Review Hardware Configuration

Edit `hardware-configuration.nix` to match your actual hardware:

```nix
# Key areas to verify:
fileSystems."/" = ...
swapDevices = ...
```

### 3. Apply the Configuration

```bash
# Build and switch to the new configuration
sudo nixos-rebuild switch --flake .#vortex

# Or use the nh alias (configured in home manager)
switch
```

### 4. Rebuild Home Manager

```bash
# Apply user-level configuration
home-manager switch --flake .#f@vortex

# Or use the nh alias
clean  # Clean old generations
switch # Rebuild system and home
```

### 5. Reboot

```bash
sudo reboot
```

## Configuration Structure

```
Vortex-Main/
├── flake.nix                    # Main flake configuration
├── flake.lock                   # Pinned dependency versions
├── hardware-configuration.nix   # Auto-generated hardware config
├── LICENSE.MD                   # MIT License
├── README.MD                    # This file
└── modules/
    ├── system/                  # System-level configuration
    │   ├── audio.nix           # PipeWire audio configuration
    │   ├── backups.nix         # Restic backup setup
    │   ├── boot.nix            # Boot loader and kernel settings
    │   ├── default.nix         # System module imports & Nix settings
    │   ├── desktop.nix         # Desktop environment setup
    │   ├── fonts.nix           # Font configuration
    │   ├── hardware.nix        # Hardware drivers (Bluetooth, GPU)
    │   ├── locale.nix          # Locale and timezone
    │   ├── networking.nix      # NetworkManager & firewall
    │   ├── packages.nix        # System-wide packages
    │   ├── programs.nix        # System programs (Firefox, Steam, etc.)
    │   ├── security.nix        # Security hardening
    │   ├── services.nix        # System services
    │   ├── users.nix           # User account configuration
    │   └── virtualisation.nix  # Docker, Podman, libvirt
    └── home/                   # Home Manager configuration
        ├── default.nix         # Home module imports & settings
        ├── packages.nix        # User packages
        ├── programs.nix        # User programs (Git, Zsh)
        ├── services.nix        # User services
        └── stylix.nix          # Theming configuration
```

## Key Features

### Desktop Environment

- **COSMIC**: System76's modern desktop environment featuring:
  - Native Wayland support
  - Dynamic workspaces
  - Window tiling capabilities
  - Customizable panel and dock

### Boot & System

- **Systemd-boot**: EFI boot manager with splash screen
- **Plymouth**: Graphical boot animation (Breeze theme)
- **Zram Swap**: Compressed swap for better memory management
- **Kernel**: Latest stable kernel with performance optimizations

### Virtualization

- **Docker**: Container runtime with:
  - Overlay2 storage driver
  - Weekly auto-pruning
  - Registry mirrors configured
  - Journald logging

- **Podman**: Rootless container management with:
  - Docker compatibility mode
  - Podman machine support (4GB RAM, 2 CPUs, 10GB disk)
  - DNS-enabled networking

- **libvirt/QEMU**: Full virtualization with:
  - Hardware acceleration (KVM)
  - OVMF UEFI firmware
  - NAT networking (192.168.122.0/24)
  - Virt-manager GUI support

### Audio & Multimedia

- **PipeWire**: Modern multimedia framework with:
  - PulseAudio compatibility
  - JACK support
  - ALSA integration
  - 32-bit audio support

### Theming

- **Stylix**: System-wide theming with:
  - Tokyo Night dark color scheme
  - Custom wallpaper
  - Consistent GTK and terminal theming
  - JetBrains Mono monospace font
  - Noto Sans/Serif fonts
  - Bibata-Modern-Ice cursor theme

### Gaming

- **Steam**: Gaming platform with:
  - Remote Play support
  - Firewall access configured

- **Lutris**: Game runner for Linux games

- **gamemode**: Performance optimization for games

### Security

- **Kernel hardening**:
  - dmesg_restrict enabled
  - kptr_restrict level 2
  - Unprivileged BPF disabled
  - Auto mitigations

- **Firewall**: iptables/nftables with:
  - Inbound connections blocked by default
  - Specific ports allowed (7777 for gaming)
  - Ping allowed

### Backup

- **Restic**: Automated backups with:
  - Daily backup schedule (02:00)
  - 1-hour random delay to prevent thundering herd
  - Retention policy: 7 daily, 4 weekly, 6 monthly

## Modules

### System Modules

#### boot.nix
Configures boot loader, kernel parameters, Plymouth, and initrd settings.

**Key options:**
- `boot.loader.systemd-boot.enable`: Enable systemd-boot
- `boot.kernelParams`: Kernel command-line parameters
- `boot.plymouth.enable`: Enable splash screen
- `zramSwap.enable`: Enable compressed swap

#### desktop.nix
Sets up the COSMIC desktop environment and display manager.

**Key options:**
- `services.desktopManager.cosmic.enable`: Enable COSMIC DE
- `services.displayManager.cosmic-greeter.enable`: Enable greeter

#### virtualisation.nix
Comprehensive virtualization setup for Docker, Podman, and libvirtd.

**Key options:**
- `virtualisation.docker.enable`: Enable Docker
- `virtualisation.podman.enable`: Enable Podman
- `virtualisation.libvirtd.enable`: Enable libvirtd

#### networking.nix
Network configuration including firewall and DNS settings.

**Key options:**
- `networking.hostName`: System hostname
- `networking.firewall.enable`: Enable firewall
- `networking.networkmanager.enable`: Enable NetworkManager

#### audio.nix
PipeWire configuration for audio/video handling.

**Key options:**
- `services.pipewire.enable`: Enable PipeWire
- `services.pipewire.pulse.enable`: Pulse compatibility
- `services.pipewire.jack.enable`: JACK support

#### hardware.nix
Hardware driver configuration.

**Key options:**
- `hardware.bluetooth.enable`: Enable Bluetooth
- `hardware.graphics.enable`: Enable GPU drivers
- `hardware.enableRedistributableFirmware`: Include firmware

#### backups.nix
Restic backup configuration.

**Key options:**
- `services.restic.backups.daily.repository`: Backup destination
- `services.restic.backups.daily.timerConfig`: Backup schedule

### Home Manager Modules

#### packages.nix
User-level packages including:

**Productivity:**
- VSCodium (editor)
- Thunderbird (email)
- Telegram Desktop (messaging)
- Bitwarden Desktop (password manager)

**Development:**
- Git (version control)
- nixfmt (formatter)
- fzf, fd, zoxide (shell utilities)
- bat (cat alternative)

**Multimedia:**
- Spotify (music)
- VLC (video player)
- REAPER (DAW)

**Browsers:**
- Chromium
- Tor Browser

**Gaming:**
- Veloren (open-world game)
- Lutris (game runner)

**Utilities:**
- eza (ls alternative)
- tree (directory tree)
- qbittorrent (torrent client)

#### programs.nix
User program configuration.

**Git:**
- Name: F
- Email: vladislavtkachuk@yahoo.com
- Default branch: main
- Rebase on pull

**Zsh:**
- Oh-My-Zsh enabled
- Plugins: git, sudo
- Aliases:
  - `boot`: `nh os boot`
  - `clean`: `nh clean all`
  - `switch`: `nh os switch`

#### stylix.nix
Visual theming configuration.

**Settings:**
- Wallpaper: Nineish dark gray
- Color scheme: Tokyo Night dark
- Font sizes: Applications (12), Terminal (14), Desktop (11)
- Opacity levels for different UI elements

## Customization

### Changing the Hostname

Edit `modules/system/networking.nix`:

```nix
networking.hostName = "your-hostname";
```

### Adding User Packages

Edit `modules/home/packages.nix`:

```nix
home.packages = with pkgs; [
  # Add your packages here
  neovim
  htop
];
```

### Modifying System Packages

Edit `modules/system/packages.nix`:

```nix
environment.systemPackages = with pkgs; [
  # Add system packages here
  htop
];
```

### Changing the Theme

Edit `modules/home/stylix.nix`:

```nix
stylix = {
  image = pkgs.nixos-artwork.wallpapers./*your-choice*/.gnomeFilePath;
  base16Scheme = "${pkgs.base16-schemes}/share/themes/*your-theme*/.yaml";
  # Adjust colors, fonts, opacity as needed
};
```

### Configuring Git

Edit `modules/home/programs.nix`:

```niff
programs.git = {
  enable = true;
  settings = {
    user.name = "Your Name";
    user.email = "your@email.com";
  };
};
```

### Adjusting Firewall Rules

Edit `modules/system/networking.nix`:

```nix
firewall = {
  enable = true;
  allowedTCPPorts = [ 80 443 ];  # Add ports here
  allowedUDPPorts = [ 80 443 ];
};
```

### Modifying Backup Settings

Edit `modules/system/backups.nix`:

```nix
services.restic.backups.daily = {
  repository = "/path/to/your/backup";
  timerConfig.OnCalendar = "03:00";  # Change schedule
  pruneOpts = [
    "--keep-daily 7"
    "--keep-weekly 4"
    "--keep-monthly 12"  # Increase monthly retention
  ];
};
```

### Enabling Stylix for System Modules

To enable system-wide theming (currently disabled), uncomment the import in `modules/system/default.nix`:

```niff
imports = [
  # ...
  ./stylix.nix  # Uncomment to enable
];
```

## Maintenance

### Updating the System

```bash
# Update flake inputs and rebuild
switch

# Or manually:
nix flake update
sudo nixos-rebuild switch --flake .#vortex
home-manager switch --flake .#f@vortex
```

### Cleaning Old Generations

```bash
# Clean using nh with configured retention policy
clean

# Manual cleanup
sudo nix-collect-garbage --delete-old
sudo nix-collect-garbage -d
```

### Rolling Back

```bash
# View generations
sudo nixos-rebuild list-generations

# Roll back to previous generation
sudo nixos-rebuild switch --generation NUMBER
```

### Updating Home Manager Only

```bash
home-manager switch --flake .#f@vortex
```

### Checking System Health

```bash
# Verify configuration
sudo nixos-rebuild dry-activate --flake .#vortex

# Check for issues
sudo nixos-checkhealth
```

## Troubleshooting

### Boot Issues

**Problem**: System fails to boot after configuration change

**Solution**:
1. Reboot and select the previous kernel from the systemd-boot menu
2. Use the fallback initrd
3. If still failing, boot from NixOS live USB and chroot:
   ```bash
   sudo nixos-enter --root /
   # Then fix the configuration
   ```

### Flake Errors

**Problem**: "flake is not allowed"

**Solution**: Ensure experimental features are enabled in `/etc/nix/nix.conf`:
```nix
experimental-features = nix-command flakes
```

### Home Manager Issues

**Problem**: Home Manager doesn't apply changes

**Solution**:
1. Check for errors in the output
2. Ensure you're using the correct flake path: `.#f@vortex`
3. Try a full switch:
   ```bash
   home-manager switch --flake .#f@vortex -b backup
   ```

### Docker/Podman Issues

**Problem**: Containers fail to start

**Solutions**:
1. Check service status: `systemctl status docker`
2. View logs: `journalctl -u docker -f`
3. Ensure user is in docker group: `groups | grep docker`

### Virtualization Issues

**Problem**: VMs fail to start

**Solutions**:
1. Verify KVM support: `ls /dev/kvm`
2. Check libvirtd status: `systemctl status libvirtd`
3. Verify user is in kvm and libvirtd groups

### Audio Issues

**Problem**: No sound

**Solutions**:
1. Check PipeWire status: `systemctl --user status pipewire`
2. Verify volume levels: `pavucontrol`
3. Check selected audio device in COSMIC settings

### Network Issues

**Problem**: Cannot connect to network

**Solutions**:
1. Check NetworkManager: `systemctl status NetworkManager`
2. View interfaces: `nmcli device`
3. Restart service: `sudo systemctl restart NetworkManager`

### Firewall Blocking Services

**Problem**: Service is unreachable

**Solution**: Add the port to allowed list in `modules/system/networking.nix`:
```nix
allowedTCPPorts = [ existing ports your-port ];
```

Then rebuild with `switch`.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## License

This configuration is licensed under the MIT License - see the [LICENSE.MD](LICENSE.MD) file for details.

## Acknowledgments

- [NixOS](https://nixos.org/) - The operating system
- [Home Manager](https://github.com/nix-community/home-manager) - User environment management
- [Stylix](https://github.com/danth/stylix) - System-wide theming
- [System76 COSMIC](https://github.com/pop-os/cosmic) - Desktop environment
- [Nix Community](https://nix-community.github.io/) - Ecosystem packages
