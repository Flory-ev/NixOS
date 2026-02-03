{ pkgs, ... }:

{
  system.stateVersion = "25.05";

  networking = {
		hostName = "vortex";
	  networkmanager.enable = true;
	};

  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.f = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "quiet"
    "splash"
    "rd.systemd.show_status=false"
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.openssh.enable = true;

  programs.zsh.enable = true;
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
		curl
		tree
    vim
    wget
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.f = import ./home.nix;
  };
}