{ config, lib, pkgs, ... }:

{
  networking = {
    firewall = {
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      enable = true;
    };

    hostName = "nixos";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];

    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };

  services.resolved = {
    dnssec = "true";
    domains = [ "~." ];
    enable = true;
    fallbackDns = [ "1.1.1.1" "1.0.0.1" ];
  };
}
