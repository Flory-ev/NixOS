# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║  system/hardware/networking.nix - Network Configuration                   ║
# ║                                                                             ║
# ║  Controls all networking:                                                   ║
# ║  - WiFi (NetworkManager)                                                    ║
# ║  - DNS servers                                                              ║
# ║  - Firewall                                                                 ║
# ║                                                                             ║
# ║  Settings from variables.nix: dns.primary, dns.secondary,                 ║
# ║  firewall.enable, firewall.openPorts                                       ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

{ variables, ... }:
{
  networking = {

    # ─────────────────────────────────────────────────────────────────────────
    # NETWORKMANAGER
    # Manages WiFi, ethernet, VPN connections
    # ─────────────────────────────────────────────────────────────────────────

    networkmanager = {
      enable = true;
      wifi.powersave = false; # Disable WiFi power saving (more stable)
    };

    # ─────────────────────────────────────────────────────────────────────────
    # DNS SERVERS
    # From variables.nix - common options:
    #   Cloudflare: 1.1.1.1 (fast, privacy)
    #   Google: 8.8.8.8 (reliable)
    #   Quad9: 9.9.9.9 (security)
    # ─────────────────────────────────────────────────────────────────────────

    nameservers = [
      variables.dns.primary
      variables.dns.secondary
    ];

    # ─────────────────────────────────────────────────────────────────────────
    # FIREWALL
    # Blocks incoming connections except for specified ports
    # ─────────────────────────────────────────────────────────────────────────

    firewall = {
      enable = variables.firewall.enable;
      allowedTCPPorts = variables.firewall.openPorts;
      allowedUDPPorts = variables.firewall.openPorts;
    };
  };

  # ─────────────────────────────────────────────────────────────────────────────
  # SYSTEMD-RESOLVED
  # Modern DNS resolver with DNSSEC support
  # ─────────────────────────────────────────────────────────────────────────────

  services.resolved = {
    enable = true;
    settings = {
      "Resolve" = {
        DNSSEC = "true"; # Verify DNS responses
        Domains = [ "~." ]; # Use for all domains

        # Fallback DNS if primary fails
        FallbackDNS = [
          variables.dns.primary
          variables.dns.secondary
        ];
      };
    };
  };
}
