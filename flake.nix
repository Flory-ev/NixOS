{
  description = "Vortex";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.vortex = nixpkgs.lib.nixosSystem {
        inherit system;
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
              # ------------------------------------------------------------------ #
              #  Nix / nixpkgs                                                     #
              # ------------------------------------------------------------------ #
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
                substituters = [ "https://cache.nixos.org/" ];
                trusted-public-keys = [
                  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                ];
              };

              nixpkgs.config.allowUnfree = true;

              system.stateVersion = "25.05";

              # ------------------------------------------------------------------ #
              #  Boot                                                               #
              # ------------------------------------------------------------------ #
              boot = {
                initrd = {
                  systemd.enable = true;
                  verbose = true;
                };

                kernel.sysctl = {
                  "kernel.dmesg_restrict" = true;
                  "kernel.kptr_restrict" = 2;
                  "kernel.unprivileged_bpf_disabled" = 1;
                };

                kernelModules = [
                  "btusb"
                  "kvm-amd"
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
                  "amd_iommu=on"
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
                algorithm = "zstd";
                memoryPercent = 50;
              };

              # ------------------------------------------------------------------ #
              #  Locale                                                             #
              # ------------------------------------------------------------------ #
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

              # ------------------------------------------------------------------ #
              #  Networking                                                         #
              # ------------------------------------------------------------------ #
              networking = {
                hostName = "vortex";
                nameservers = [
                  "1.1.1.1"
                  "8.8.8.8"
                ];
                wireguard.enable = false;

                firewall = {
                  enable = true;
                  allowPing = true;
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

              services.resolved.enable = true;

              # ------------------------------------------------------------------ #
              #  Hardware                                                           #
              # ------------------------------------------------------------------ #
              hardware = {
                bluetooth = {
                  enable = true;
                  powerOnBoot = true;
                  settings.General.Experimental = true;
                };
                enableRedistributableFirmware = true;
                firmware = [ pkgs.linux-firmware ];
                graphics = {
                  enable = true;
                  enable32Bit = true;
                };
                ksm.enable = true;
              };

              # ------------------------------------------------------------------ #
              #  Desktop / Audio / Fonts                                           #
              # ------------------------------------------------------------------ #
              services.displayManager.cosmic-greeter.enable = true;
              services.desktopManager.cosmic.enable = true;

              services.pipewire = {
                enable = true;
                pulse.enable = true;
                jack.enable = true;
                wireplumber.enable = true;
                alsa = {
                  enable = true;
                  support32Bit = true;
                };
              };

              fonts = {
                fontconfig.enable = true;
                packages = with pkgs; [
                  fira-code
                  font-awesome
                  jetbrains-mono
                  noto-fonts
                  noto-fonts-cjk-sans
                  noto-fonts-color-emoji
                ];
              };

              # ------------------------------------------------------------------ #
              #  Programs                                                           #
              # ------------------------------------------------------------------ #
              programs = {
                firefox.enable = true;
                gamemode.enable = true;

                steam = {
                  enable = true;
                  remotePlay.openFirewall = true;
                };

                zsh = {
                  enable = true;
                  enableCompletion = true;
                  autosuggestions.enable = true;
                  syntaxHighlighting.enable = true;
                };

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

              # ------------------------------------------------------------------ #
              #  Services                                                           #
              # ------------------------------------------------------------------ #
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

                libinput = {
                  enable = true;
                  touchpad = {
                    tapping = true;
                    naturalScrolling = true;
                    disableWhileTyping = false;
                  };
                };

                earlyoom = {
                  enable = true;
                  freeMemThreshold = 5;
                  freeSwapThreshold = 10;
                };

                fstrim.enable = true;
                fwupd.enable = true;
                logrotate.enable = true;
                smartd.enable = true;
                thermald.enable = true;
                power-profiles-daemon.enable = lib.mkForce false;

                locate = {
                  enable = true;
                  package = pkgs.plocate;
                  interval = "daily";
                };

                restic.backups = {
                  daily = {
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
              };

              # ------------------------------------------------------------------ #
              #  Security                                                           #
              # ------------------------------------------------------------------ #
              security.sudo.wheelNeedsPassword = true;

              # ------------------------------------------------------------------ #
              #  Virtualisation                                                     #
              # ------------------------------------------------------------------ #
              virtualisation = {
                docker = {
                  enable = true;
                  enableOnBoot = true;
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
                    swtpm.enable = true;
                  };
                  onBoot = "start";
                  onShutdown = "shutdown";
                };

                spiceUSBRedirection.enable = true;
              };

              # ------------------------------------------------------------------ #
              #  Users                                                              #
              # ------------------------------------------------------------------ #
              users.users.f = {
                description = "F";
                isNormalUser = true;
                shell = pkgs.zsh;
                extraGroups = [
                  "audio"
                  "docker"
                  "input"
                  "kvm"
                  "libvirtd"
                  "networkmanager"
                  "storage"
                  "video"
                  "wheel"
                ];
              };

              # ------------------------------------------------------------------ #
              #  System packages                                                    #
              # ------------------------------------------------------------------ #
              environment.systemPackages = with pkgs; [
                curl
                nixfmt
                wget
                restic
                virt-viewer
                libguestfs
                guestfs-tools
                spice
                spice-gtk
                spice-protocol
                virtio-win
                win-spice
              ];

              environment.sessionVariables = {
                LIBVIRT_DEFAULT_URI = "qemu:///system";
              };

              # ------------------------------------------------------------------ #
              #  Home Manager                                                       #
              # ------------------------------------------------------------------ #
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                useGlobalPkgs = false;
                useUserPackages = true;
                users.f =
                  { pkgs, inputs, ... }:
                  {
                    nixpkgs.config.allowUnfree = true;

                    home = {
                      username = "f";
                      homeDirectory = "/home/f";
                      stateVersion = "25.05";

                      packages = with pkgs; [
                        antigravity
                        bat
                        bitwarden-desktop
                        chromium
                        discord
                        eza
                        fd
                        fzf
                        lutris
                        nixfmt
                        qbittorrent
                        reaper
                        spotify
                        telegram-desktop
                        thunderbird
                        tor-browser
                        tree
                        veloren
                        vlc
                        vscodium
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

                    services = { };

                    # Uncomment to enable Stylix theming:
                    # imports = [ inputs.stylix.homeModules.stylix ];
                    # stylix = {
                    #   enable = true;
                    #   image = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
                    #   base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
                    #   cursor = { package = pkgs.bibata-cursors; name = "Bibata-Modern-Ice"; size = 20; };
                    #   fonts = {
                    #     monospace = { package = pkgs.jetbrains-mono; name = "JetBrains Mono"; };
                    #     sansSerif = { package = pkgs.noto-fonts; name = "Noto Sans"; };
                    #     serif = { package = pkgs.noto-fonts; name = "Noto Serif"; };
                    #     sizes = { applications = 12; terminal = 14; desktop = 11; popups = 10; };
                    #   };
                    #   opacity = { applications = 0.9; terminal = 0.8; desktop = 0.95; popups = 0.85; };
                    #   targets = { gnome.enable = true; gtk.enable = true; };
                    # };
                  };
              };
            }
          )
        ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
