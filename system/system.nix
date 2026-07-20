{ ... }:
{
  time.timeZone = "Europe/Copenhagen";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
  ];
  console.keyMap = "us";

  documentation = {
    enable = false;
    nixos.enable = false;
    man.enable = false;
  };

  powerManagement.cpuFreqGovernor = "performance";
  zramSwap.enable = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dde0enMB6oXQ5yOtIyBTD6jLMOx3SoLDA=" ];
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
