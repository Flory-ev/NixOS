{ ... }:

{
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];

    firewall = {
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      enable = true;
    };
  };

  services.resolved = {
    enable = true;
    settings = {
      "Resolve" = {
        DNSSEC = "true";
        Domains = [ "~." ];
        FallbackDNS = [
          "1.1.1.1"
          "1.0.0.1"
        ];
      };
    };
  };
}
