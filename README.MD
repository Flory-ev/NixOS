# Vortex - NixOS Configuration
A modern, modular NixOS configuration using flakes, Home Manager, and the COSMIC desktop environment. This configuration provides a complete desktop environment with virtualization support, gaming features, and integrated system maintenance.
## Table of Contents
 * Overview
 * Prerequisites
 * Installation
 * Configuration Structure
 * Key Features
 * Modules
 * Customization
 * Maintenance
 * Troubleshooting
## Overview
**Vortex** is a declarative NixOS configuration designed for a polished desktop experience. It leverages Nix flakes for reproducible system states and Home Manager for granular user-level package management.
 * **Base System**: NixOS unstable (nixos-unstable channel)
 * **Architecture**: x86_64-linux
 * **Desktop Environment**: System76 COSMIC
 * **User**: f (F)
 * **State Version**: 25.05
 * **Shell**: Zsh with Oh-My-Zsh
## Prerequisites
Before using this configuration, ensure you have:
 1. A working NixOS installation with stateVersion 25.05.
 2. Hardware virtualization support enabled in BIOS (Intel-VT/AMD-V).
 3. Experimental features enabled in /etc/nix/nix.conf:
   ```nix
   experimental-features = nix-command flakes
   
   ```
## Installation
### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/vortex ~/.config/nixos
cd ~/.config/nixos

```
### 2. Apply the Configuration
The system uses the nh helper for streamlined rebuilds.
```bash
# Build and switch to the system configuration
sudo nixos-rebuild switch --flake .#vortex

# Or use the pre-configured alias
switch

```
## Key Features
### Desktop & UI
 * **DE**: COSMIC Desktop with cosmic-greeter.
 * **Fonts**: Includes Fira Code, Font Awesome, JetBrains Mono, and Noto Fonts.
 * **Input**: Touchpad tapping and natural scrolling enabled; libinput configured to stay active while typing.
### Virtualization & Containers
 * **Docker**: Enabled with weekly auto-pruning of containers older than 24 hours.
 * **Podman**: Enabled with DNS support for container networking.
 * **Libvirt/QEMU**: Configured for user sessions (qemu:///system) with virt-manager, SPICE support, and TPM emulation.
### Performance & Power
 * **TLP**: Optimized for laptops with performance on AC and powersave on battery; battery charge thresholds set at 75%-80%.
 * **Zram**: Compressed swap enabled.
 * **EarlyOOM**: Configured to prevent system hangs with a 5% memory and 10% swap threshold.
 * **Kernel**: Running linuxPackages_latest with IOMMU enabled and auto-mitigations.
### Gaming
 * **Steam**: Open firewall for Remote Play and pre-installed proton-ge-bin.
 * **GameMode**: Enabled for performance optimization.
### Backup & Security
 * **Restic**: Daily backups at 02:00 (with a 1-hour randomized delay) to /run/media/f/Backup/vortex-backup.
 * **Hardening**: Restricted dmesg, kptr, and unprivileged BPF.
 * **Firewall**: Active with TCP/UDP port 7777 allowed.
## Modules
### Home Manager (User: f)
 * **Git**: Configured for vladislavtkachuk@yahoo.com with rebase on pull enabled.
 * **Zsh Aliases**:
   * boot: nh os boot
   * clean: nh clean all
   * switch: nh os switch
 * **Packages**: Includes spotify, reaper, telegram-desktop, tor-browser, qbittorrent, and CLI tools like eza, bat, and zoxide.
### System Services
 * **Audio**: PipeWire with PulseAudio, JACK, and 32-bit ALSA support.
 * **Networking**: NetworkManager using iwd backend; DNS handled via systemd-resolved with Cloudflare (1.1.1.1) and Google (8.8.8.8) providers.
 * **Updates**: fwupd for firmware updates and fstrim for SSD maintenance.
## Maintenance
### System Updates
Update flake inputs and the system:
```bash
nix flake update
switch

```
### Cleanup
The nh tool is configured to automatically keep only the last 3 generations or those from the last 4 days.
```bash
clean

```
## Troubleshooting
 * **Locale/Keyboard**: System is set to en_US.UTF-8 with a Danish (dk) keymap.
 * **Binary Compatibility**: nix-ld is enabled with standard C libraries to run unpatched binaries.
 * **AppImages**: Supported via appimage and binfmt.
