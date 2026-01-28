# NixOS Configuration

A modular, flake-based NixOS configuration with support for multiple machine profiles.

## 🚀 Quick Start

```bash
# Clone the repository
git clone <your-repo> ~/nixos
cd ~/nixos

# Rebuild system
sudo nixos-rebuild switch --flake .#vortex

# Update flake inputs
nix flake update

# Using nh (if configured)
nh os switch
```

## 📁 Structure

```
.
├── flake.nix                 # Flake entry point
├── flake.lock                # Locked dependencies
│
├── hosts/                    # Host-specific configurations
│   └── vortex/
│       ├── default.nix
│       └── hardware-configuration.nix
│
├── profiles/                 # Machine profiles
│   ├── base.nix             # Base configuration (imported by all)
│   ├── desktop.nix          # Desktop machine profile
│   └── laptop.nix           # Laptop machine profile
│
├── system/                   # System-level configuration
│   ├── core/                # Core system settings
│   │   ├── boot.nix         # Boot loader & kernel
│   │   ├── locale.nix       # Localization & timezone
│   │   ├── security.nix     # Security & sudo
│   │   └── settings.nix     # Nix settings & flakes
│   │
│   ├── hardware/            # Hardware configuration
│   │   ├── audio.nix        # PipeWire audio
│   │   ├── bluetooth.nix    # Bluetooth setup
│   │   ├── graphics.nix     # GPU configuration
│   │   ├── networking.nix   # NetworkManager & firewall
│   │   └── virtualization.nix # libvirt & QEMU
│   │
│   ├── desktop/             # Desktop environment
│   │   ├── desktop.nix      # DE configuration (COSMIC + Plasma 6)
│   │   └── stylix.nix       # System-wide theming
│   │
│   └── software/            # System software
│       ├── packages.nix     # System packages
│       ├── programs.nix     # System programs
│       └── services.nix     # System services
│
└── home/                     # Home Manager configuration
    ├── core/
    │   ├── home.nix         # Home Manager entry point
    │   └── users.nix        # User definitions
    │
    └── software/
        ├── packages.nix     # User packages
        └── programs.nix     # User programs (zsh, git, etc.)
```

## 🖥️ Current Setup

**Host:** vortex  
**Profile:** laptop  
**Desktop Environments:** COSMIC + Plasma 6 (default: Plasma)  
**Display Manager:** COSMIC Greeter  
**Theme:** Gruvbox Dark Hard (via Stylix)  
**Shell:** Zsh with Oh My Zsh

### Key Features

- **Power Management:** TLP with battery care (20-80% charging)
- **Memory:** Zram (50% compression) + earlyoom protection
- **Touchpad:** Natural scrolling, tap-to-click, clickfinger
- **Security:** Fingerprint reader support
- **Virtualization:** libvirt with virt-manager
- **Auto-cleanup:** Weekly Nix store optimization

## 🎨 Customization

### Theming (Stylix)

Edit `system/desktop/stylix.nix`:

```nix
base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
polarity = "dark";
```

Available themes in `pkgs.base16-schemes/share/themes/`

### Desktop Environment

Edit `system/desktop/desktop.nix`:

```nix
services.displayManager.defaultSession = "plasma";  # or "cosmic"
```

### Power Management

Adjust battery thresholds in `profiles/laptop.nix`:

```nix
START_CHARGE_THRESH_BAT0 = 20;
STOP_CHARGE_THRESH_BAT0 = 80;
```

## 📦 Adding Packages

**System packages:** `system/software/packages.nix`  
**User packages:** `home/software/packages.nix`

```nix
# Add to appropriate file
environment.systemPackages = with pkgs; [
  neofetch
];
```

## 🔧 Common Tasks

### Add a New Host

1. Generate hardware configuration:
   ```bash
   nixos-generate-config --show-hardware-config > hosts/newhost/hardware-configuration.nix
   ```

2. Create `hosts/newhost/default.nix`:
   ```nix
   { ... }:
   {
     imports = [
       ./hardware-configuration.nix
       ../../profiles/desktop.nix  # or laptop.nix
     ];
     networking.hostName = "newhost";
   }
   ```

3. Add to `flake.nix`:
   ```nix
   nixosConfigurations.newhost = nixpkgs.lib.nixosSystem {
     system = "x86_64-linux";
     specialArgs = { inherit inputs; };
     modules = [
       ./hosts/newhost
       # ... other modules
     ];
   };
   ```

### Enable a Service

Add to appropriate `services.nix` or directly in profile:

```nix
services.myservice.enable = true;
```

### Update System

```bash
# Update flake inputs
nix flake update

# Rebuild with new inputs
sudo nixos-rebuild switch --flake .#vortex

# Or with nh
nh os switch
```

### Cleanup Old Generations

```bash
# Manual
sudo nix-collect-garbage -d

# Or let nh handle it (configured for 4 days, keep 3)
nh clean all
```

## 🛠️ Profiles

### Base Profile
Core system configuration imported by all machines:
- Boot configuration
- Localization
- Security settings
- Networking
- Common services

### Laptop Profile
Extends base with:
- TLP power management
- Thermald
- Libinput touchpad configuration
- Battery care
- NVMe optimization
- Zram swap
- Earlyoom protection

### Desktop Profile
Extends base with:
- Full graphics support
- Disk management services
- Minimal power management

## 🔐 Security Features

- Firewall enabled (Cloudflare DNS)
- DNSSEC validation
- Sudo with wheel group
- Fingerprint authentication
- Session locking on suspend

## 📝 Notes

- User: `f`
- Flake location: `/home/f/nixos` (configured in nh)
- Auto-optimization: Weekly
- Garbage collection: Automatic via nh (keeps last 3 generations, 4+ days old)
- Boot entries: Limited to 10

## 🐛 Troubleshooting

### NVMe SSD issues
The laptop profile includes `nvme_core.default_ps_max_latency_us=0` to prevent NVMe freezes. Remove if not needed.

### Battery not charging to 100%
This is intentional (20-80% rule for battery longevity). Adjust in `profiles/laptop.nix` if needed.

### Desktop session not changing
After changing `defaultSession`, you may need to clear your previous session selection at login.

## 📚 Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Stylix Documentation](https://danth.github.io/stylix/)
- [Base16 Themes](https://github.com/base16-project/base16-schemes)

## 📄 License

MIT
