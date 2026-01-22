{ config, lib, pkgs, ... }:

{
  networking = {
    firewall = {
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      enable = true;
    };

    hostName = "vortex";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];

    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
  };

  services.resolved = {
    enable = true; 
    settings = {
      Resolve.FallbackDNS = [ "1.1.1.1" "1.0.0.1" ];
      Resolve.dnssec = "true";
      Resolve.Domains = [ "~." ];
    };    
  };
}
