{
  # User Identity
  username = "f";
  fullName = "F";
  email = "vladislavtkachuk@yahoo.com";
  hostname = "vortex";
  system = "x86_64-linux";
  stateVersion = "25.05";
  flakePath = "/home/f/nixos";

  # Desktop
  desktopEnvironment = "plasma";
  defaultSession = "plasma";

  # Localization
  timezone = "Europe/Copenhagen";
  locale = "en_US.UTF-8";
  supportedLocales = [ "en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" ];
  
  keyboard = {
    layout = "us,ru";
    variant = "";
    options = "grp:alt_shift_toggle";
  };

  console = {
    fontPackage = "terminus_font";
    font = "ter-v16n";
  };

  # Default Apps
  defaultShell = "zsh";
  terminal = "kitty";
  terminalMultiplexer = "tmux";
  editor = "vscodium";
  browser = "chromium";

  # Git
  git = {
    defaultBranch = "main";
    gpgSign = false;
    gpgKey = "";
    pullRebase = true;
  };

  # Network & Security
  dns = {
    primary = "1.1.1.1";
    secondary = "1.0.0.1";
  };

  firewall = {
    enable = true;
    openPorts = [ 7777 ];
    openUDPPorts = [ ];
    allowPing = true;
    logRefused = true;
  };

  vpn.wireguard.enable = false;

  security = {
    hardening = true;
    sudoNeedsPassword = true;
    apparmor = false;
    sshHardening = false;
  };

  # Boot & Performance
  boot = {
    silent = true;
    plymouth = true;
    plymouthTheme = "breeze";
    configLimit = 10;
    timeout = 5;
    mitigations = true;
  };

  performance = {
    zram = true;
    ksm = true;
  };

  gc = {
    automatic = true;
    frequency = "weekly";
    olderThan = "7d";
    keep = 3;
  };

  nix = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trustedPublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    overlays = [ ];
  };

  # Hardware
  hardware = {
    bluetooth = true;
    audio = true;
    graphics = true;
    videoAcceleration = true;
    printing = false;
    scanning = false;
    virtualization = true;
  };

  laptop.enable = true;

  containers = {
    docker = false;
    dockerStorageDriver = "overlay2";
    dockerAutoStart = false;
    podman = false;
  };

  # Gaming
  gaming = {
    enable = true;
    steam = true;
    gamescope = false;
    lutris = false;
    heroic = false;
    prismLauncher = false;
    mangohud = false;
  };

  # Theming
  theme = {
    style = "dark";
    accentColor = "blue";
    font = {
      mono = "JetBrains Mono";
      sans = "Noto Sans";
      serif = "Noto Serif";
      size = 11;
    };
  };

  # Applications
  apps = {
    discord = true;
    telegram = true;
    slack = false;
    thunderbird = false;
    element = false;
    vlc = true;
    mpv = false;
    spotify = true;
    obs = false;
    ffmpeg = false;
    gimp = false;
    inkscape = false;
    krita = false;
    libreoffice = true;
    flameshot = true;
  };

  # Advanced
  kernelParams = [ ];
  extraSystemPackages = [ ];
  extraUserPackages = [ ];
  environmentVariables = { };
  systemdServices = { };
}
