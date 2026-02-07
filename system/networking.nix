{ config, lib, pkgs, ... }:

{
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
      wifi = {
        backend = "iwd";
        powersave = false;
      };
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
}
