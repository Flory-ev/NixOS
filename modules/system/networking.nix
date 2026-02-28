{
  config,
  lib,
  pkgs,
  ...
}:

{
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

  services.resolved = {
    enable = true;
  };
}
