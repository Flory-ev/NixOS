{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    {
      nixosConfigurations.vortex = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          inputs.home-manager.nixosModules.home-manager
          (
            {
              lib,
              pkgs,
              inputs,
              ...
            }:
            {

              # --- Home Manager ---
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.f =
                  { pkgs, ... }:
                  {
                    home = {
                      username = "f";
                      homeDirectory = "/home/f";
                      stateVersion = "25.05";
                      packages = with pkgs; [
                        antigravity
                        bat
                        eza
                        fd
                        fzf
                        qbittorrent
                        reaper
                        spotify
                        telegram-desktop
                        tor-browser
                        tree
                        zoxide
                      ];
                    };
                    programs = {
                      git = {
                        enable = true;
                        settings = {
                          user.name = "F";
                          user.email = "vladislavtkachuk@yahoo.com";
                          init.defaultBranch = "main";
                          pull.rebase = true;
                          push.autoSetupRemote = true;
                        };
                      };
                      zsh = {
                        enable = true;
                        enableCompletion = true;
                        autosuggestion.enable = true;
                        syntaxHighlighting.enable = true;
                        oh-my-zsh = {
                          enable = true;
                          plugins = [
                            "git"
                            "sudo"
                          ];
                        };
                        shellAliases = {
                          boot = "nh os boot";
                          clean = "nh clean all";
                          switch = "nh os switch";
                        };
                      };
                    };
                  };
              };

              # --- Environment ---
              environment = {
                systemPackages = with pkgs; [
                  curl
                  nixfmt
                  wget
                  guestfs-tools
                  spice
                  spice-gtk
                  virt-viewer
                  virtio-win
                  win-spice
                ];
                sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";
              };

              # --- Virtualisation ---
              virtualisation = {
                docker = {
                  enable = true;
                  autoPrune = {
                    enable = true;
                    flags = [
                      "--all"
                      "--filter"
                      "until=24h"
                    ];
                    dates = "weekly";
                  };
                };
                podman = {
                  enable = true;
                  defaultNetwork.settings.dns_enabled = true;
                };
                libvirtd = {
                  enable = true;
                  qemu = {
                    package = pkgs.qemu_kvm;
                    runAsRoot = false;
                    swtpm.enable = true;
                  };
                  onBoot = "start";
                  onShutdown = "shutdown";
                };
                spiceUSBRedirection.enable = true;
              };

              # --- Services ---
              services = {
                flatpak.enable = true;
                tlp = {
                  enable = true;
                  settings = {
                    CPU_SCALING_GOVERNOR_ON_AC = "performance";
                    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
                    START_CHARGE_THRESH_BAT0 = 75;
                    STOP_CHARGE_THRESH_BAT0 = 80;
                  };
                };
                libinput.touchpad = {
                  tapping = true;
                  naturalScrolling = true;
                  disableWhileTyping = false;
                };
                earlyoom = {
                  enable = true;
                  freeMemThreshold = 5;
                  freeSwapThreshold = 10;
                };
                fstrim.enable = true;
                fwupd.enable = true;
                smartd.enable = true;
                thermald.enable = true;
                power-profiles-daemon.enable = lib.mkForce false;
                locate = {
                  enable = true;
                  package = pkgs.plocate;
                  interval = "daily";
                };
                restic.backups.daily = {
                  repository = "/run/media/f/Backup/vortex-backup";
                  passwordFile = "/etc/restic/password";
                  paths = [
                    "/home/f"
                    "/etc"
                  ];
                  exclude = [
                    ".cache"
                    "Downloads"
                    "node_modules"
                    "target"
                  ];
                  timerConfig = {
                    OnCalendar = "02:00";
                    RandomizedDelaySec = "1h";
                  };
                  pruneOpts = [
                    "--keep-daily 7"
                    "--keep-weekly 4"
                    "--keep-monthly 6"
                  ];
                };
              };
              services.resolved.enable = true;
              services.displayManager.cosmic-greeter.enable = true;
              services.desktopManager.cosmic.enable = true;
              services.pipewire = {
                enable = true;
                pulse.enable = true;
                jack.enable = true;
                alsa = {
                  enable = true;
                  support32Bit = true;
                };
              };

              # --- Programs ---
              programs = {
                firefox.enable = true;
                gamemode.enable = true;
                steam = {
                  enable = true;
                  remotePlay.openFirewall = true;
                  extraCompatPackages = with pkgs; [ proton-ge-bin ];
                };
                zsh.enable = true;
                appimage = {
                  enable = true;
                  binfmt = true;
                };
                nix-ld = {
                  enable = true;
                  libraries = with pkgs; [
                    stdenv.cc.cc
                    zlib
                  ];
                };
                nh = {
                  enable = true;
                  flake = "/home/f/vortex";
                  clean = {
                    enable = true;
                    extraArgs = "--keep 3 --keep-since 4d";
                  };
                };
                virt-manager.enable = true;
              };

              # --- Fonts ---
              fonts.packages = with pkgs; [
                fira-code
                font-awesome
                jetbrains-mono
                noto-fonts
                noto-fonts-cjk-sans
                noto-fonts-color-emoji
              ];

              # --- Users ---
              users.users.f = {
                description = "F";
                isNormalUser = true;
                shell = pkgs.zsh;
                extraGroups = [
                  "docker"
                  "input"
                  "kvm"
                  "libvirtd"
                  "networkmanager"
                  "video"
                  "wheel"
                ];
              };

              # --- Networking ---
              networking = {
                hostName = "vortex";
                nameservers = [
                  "1.1.1.1"
                  "8.8.8.8"
                ];
                firewall = {
                  enable = true;
                  allowedTCPPorts = [ 7777 ];
                  allowedUDPPorts = [ 7777 ];
                  logRefusedConnections = false;
                };
                networkmanager = {
                  enable = true;
                  dns = "systemd-resolved";
                  wifi = {
                    backend = "iwd";
                    powersave = false;
                  };
                };
              };

              # --- Hardware ---
              hardware = {
                bluetooth = {
                  enable = true;
                  powerOnBoot = true;
                  settings.General.Experimental = true;
                };
                enableRedistributableFirmware = true;
                graphics.enable32Bit = true;
                ksm.enable = true;
              };

              # --- Locale ---
              time.timeZone = "Europe/Copenhagen";
              i18n = {
                defaultLocale = "en_US.UTF-8";
                supportedLocales = [
                  "en_US.UTF-8/UTF-8"
                  "ru_RU.UTF-8/UTF-8"
                ];
              };
              console = {
                font = "Lat2-Terminus16";
                keyMap = "dk";
                packages = [ pkgs.terminus_font ];
              };

              # --- Boot ---
              boot = {
                initrd.systemd.enable = true;
                kernel.sysctl = {
                  "kernel.dmesg_restrict" = true;
                  "kernel.kptr_restrict" = 2;
                  "kernel.unprivileged_bpf_disabled" = 1;
                };
                kernelModules = [
                  "btusb"
                  "kvm-intel"
                  "vfio-pci"
                  "vhost-net"
                  "tap"
                  "tun"
                ];
                kernelPackages = pkgs.linuxPackages_latest;
                kernelParams = [
                  "mitigations=auto"
                  "quiet"
                  "splash"
                  "intel_iommu=on"
                  "iommu=pt"
                ];
                loader = {
                  efi.canTouchEfiVariables = true;
                  timeout = 5;
                  systemd-boot = {
                    enable = true;
                    editor = false;
                    consoleMode = "max";
                    configurationLimit = 10;
                  };
                };
                plymouth = {
                  enable = true;
                  theme = "breeze";
                };
                tmp.cleanOnBoot = true;
              };
              zramSwap = {
                enable = true;
                memoryPercent = 50;
              };

              # --- Nix ---
              environment.etc."nix/inputs/nixpkgs".source = inputs.nixpkgs.outPath;
              nix.settings = {
                auto-optimise-store = true;
                download-buffer-size = 200000000;
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];
                flake-registry = "";
                nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
              };
              nixpkgs.config.allowUnfree = true;
              system.stateVersion = "25.05";

            }
          )
        ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    };
}
