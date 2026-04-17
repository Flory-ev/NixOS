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
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.nixfmt;

      nixosConfigurations.vortex = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          inputs.home-manager.nixosModules.home-manager
          (
            { pkgs, ... }:
            {
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
                  "quiet"
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
              };
              zramSwap.enable = true;

              # --- System ---
              time.timeZone = "Europe/Copenhagen";
              i18n.supportedLocales = [
                "en_US.UTF-8/UTF-8"
                "ru_RU.UTF-8/UTF-8"
              ];
              console.keyMap = "us";

              # --- Hardware ---
              hardware = {
                bluetooth = {
                  enable = true;
                  powerOnBoot = true;
                  settings.General.Experimental = true;
                };
                graphics.enable32Bit = true;
              };

              # --- Networking ---
              networking = {
                hostName = "vortex";
                firewall = {
                  enable = true;
                  allowedTCPPorts = [ 7777 ];
                  allowedUDPPorts = [ 7777 ];
                  logRefusedConnections = false;
                  trustedInterfaces = [ "virbr0" ];
                };
                networkmanager = {
                  enable = true;
                  dns = "systemd-resolved";
                  wifi = {
                    backend = "iwd";
                    powersave = false;
                  };
                };
                tempAddresses = "enabled";
              };

              # --- Services ---
              services.resolved = {
                enable = true;
                dnssec = "allow-downgrade";
                dns = [
                  "1.1.1.1#cloudflare-dns.com"
                  "8.8.8.8#dns.google"
                ];
                fallbackDns = [
                  "9.9.9.9#dns.quad9.net"
                ];
              };

              # --- Virtualisation ---
              virtualisation = {
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
              environment = {
                systemPackages = with pkgs; [
                  curl
                  nixfmt
                  wget
                  spice
                  spice-gtk
                  virt-viewer
                  virtio-win
                  win-spice
                ];
                sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";
              };

              # --- Programs ---
              programs = {
                appimage = {
                  enable = true;
                  binfmt = true;
                };
                firefox.enable = true;
                gamemode.enable = true;
                niri.enable = true;
                nh = {
                  enable = true;
                  flake = "/home/f/vortex";
                  clean = {
                    enable = true;
                    extraArgs = "--keep 3 --keep-since 4d";
                  };
                };
                nix-ld = {
                  enable = true;
                  libraries = with pkgs; [
                    stdenv.cc.cc
                    zlib
                  ];
                };
                steam = {
                  enable = true;
                  remotePlay.openFirewall = true;
                  extraCompatPackages = with pkgs; [ proton-ge-bin ];
                };
                virt-manager.enable = true;
                zsh.enable = true;
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
                isNormalUser = true;
                shell = pkgs.zsh;
                extraGroups = [
                  "input"
                  "kvm"
                  "libvirtd"
                  "networkmanager"
                  "video"
                  "wheel"
                ];
              };

              # --- Home Manager ---
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.f = _: {
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
                      autosuggestion.enable = true;
                      syntaxHighlighting.enable = true;
                      oh-my-zsh = {
                        enable = true;
                        plugins = [
                          "git"
                          "sudo"
                        ];
                      };
                    };
                  };
                };
              };

              # --- Nix ---
              nix.settings = {
                experimental-features = [
                  "nix-command"
                  "flakes"
                ];
                substituters = [ "https://nix-community.cachix.org" ];
                trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dde0enMB6oXQ5yOtIyBTD6jLMOx3SoLDA=" ];
              };
              nixpkgs.config.allowUnfree = true;
              system.stateVersion = "25.05";
            }
          )
        ];
      };
    };
}
