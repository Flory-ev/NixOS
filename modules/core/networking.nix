{ ... }:
{
  # --- Networking ---
  networking = {
    firewall = {
      allowedTCPPorts = [ 7777 ];
      allowedUDPPorts = [ 7777 ];
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

  # --- iwd settings: prefer 5 GHz to avoid 2.4 GHz congestion ---
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        RoamRetryInterval = 15;
      };
      Rank = {
        BandModifier5Ghz = 2.0; # Strongly prefer 5 GHz networks
      };
    };
  };
}
