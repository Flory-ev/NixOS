{
  description = "Vortex";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;

    nixosConfigurations.vortex = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        ./hardware-configuration.nix

        ({ config, lib, pkgs, ... }: {
          # --- User ---
          users.users.f = {
            isNormalUser = true;
            shell = pkgs.zsh;
            extraGroups = [ "docker" "libvirtd" "networkmanager" "wheel" ];
          };

          # --- Boot ---
          boot = {
            consoleLogLevel = 3;
            initrd = { systemd.enable = true; verbose = true; };
            kernel.sysctl = {
              "kernel.dmesg_restrict" = true;
              "kernel.kptr_restrict" = 2;
              "kernel.unprivileged_bpf_disabled" = 1;
            };
            kernelModules = [ "btusb" ];
            kernelPackages = pkgs.linuxPackages_latest;
            kernelParams = [ "mitigations=auto" "quiet" "splash" ];
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
            plymouth = { enable = true; theme = "breeze"; };
            tmp.cleanOnBoot = true;
          };

          zramSwap = { enable = true; algorithm = "zstd"; memoryPercent = 50; };

          # --- Networking ---
          networking = {
            hostName = "vortex";
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
              wifi = { backend = "iwd"; powersave = false; };
            };
          };

          services.resolved = {
            enable = true;
            settings.Resolve = {
              DNSSEC = "true";
              DNSOverTLS = "opportunistic";
              FallbackDNS = "1.1.1.1 8.8.8.8";
            };
          };

          # --- Localization ---
          time.timeZone = "Europe/Copenhagen";
          i18n = {
            defaultLocale = "en_US.UTF-8";
            supportedLocales = [ "en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" ];
          };
          console = {
            font = "Lat2-Terminus16";
            keyMap = "dk";
            packages = [ pkgs.terminus_font ];
          };

          # --- Fonts ---
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

          # --- Hardware ---
          hardware = {
            bluetooth = {
              enable = true;
              powerOnBoot = true;
              settings.General.Experimental = true;
            };
            enableRedistributableFirmware = true;
            firmware = [ pkgs.linux-firmware ];
            graphics = { enable = true; enable32Bit = true; };
            ksm.enable = true;
          };

          # --- Programs ---
          environment.systemPackages = with pkgs; [ curl wget ];

          programs = {
            firefox.enable = true;
            gamemode.enable = true;
            virt-manager.enable = true;

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

            appimage = { enable = true; binfmt = true; };

            nix-ld = {
              enable = true;
              libraries = with pkgs; [ stdenv.cc.cc zlib ];
            };

            nh = {
              enable = true;
              flake = "/home/f/vortex";
              clean = { enable = true; extraArgs = "--keep 3 --keep-since 4d"; };
            };
          };

          # --- Services ---
          services = {
            displayManager.cosmic-greeter.enable = true;
            desktopManager.cosmic.enable = true;

            pipewire = {
              enable = true;
              pulse.enable = true;
              jack.enable = true;
              wireplumber.enable = true;
              alsa = { enable = true; support32Bit = true; };
            };

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
          };

          # --- Virtualisation ---
          virtualisation = {
            docker = { enable = true; enableOnBoot = true; storageDriver = "overlay2"; };
            libvirtd = { enable = true; qemu.package = pkgs.qemu_kvm; };
            podman = { enable = true; defaultNetwork.settings.dns_enabled = true; };
          };

          # --- Nix ---
          nix = {
            settings = {
              auto-optimise-store = true;
              experimental-features = [ "nix-command" "flakes" ];
              flake-registry = "";
              nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
              substituters = [ "https://cache.nixos.org/" ];
              trusted-public-keys = [
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              ];
            };
          };

          environment.etc."nix/inputs/nixpkgs".source = inputs.nixpkgs.outPath;
          nixpkgs.config.allowUnfree = true;

          # --- Security ---
          security.sudo.wheelNeedsPassword = true;
          system.stateVersion = "25.05";
        })

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            extraSpecialArgs = { inherit inputs; };
            useGlobalPkgs = true;
            useUserPackages = true;

            users.f = { config, pkgs, ... }: {
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
                  qbittorrent
                  reaper
                  spotify
                  telegram-desktop
                  thunderbird
                  tor-browser
                  tree
                  vlc
                  vscodium
                  zoxide
                ];
              };

              programs = {
                git = {
                  enable = true;
                  settings = {
                    init.defaultBranch = "main";
                    pull.rebase = true;
                    push.autoSetupRemote = true;
                    user.name = "F";
                    user.email = "vladislavtkachuk@yahoo.com";
                  };
                };

                zsh = {
                  enable = true;
                  enableCompletion = true;
                  autosuggestion.enable = true;
                  syntaxHighlighting.enable = true;

                  oh-my-zsh = {
                    enable = true;
                    plugins = [ "git" "sudo" ];
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
        }
      ];
    };
  };
}
