{ pkgs, ... }:

{
  services.restic.backups = {
    daily = {
      repository = "/run/media/f/Backup/vortex-backup"; # Local path example
      passwordFile = "/etc/restic/password"; # Path to file containing backup password
      paths = [
        "/home/f"
        "/etc"
      ];
      exclude = [
        ".cache"
        "Downloads"
        "node_modules"
        "target"
      ];
      timerConfig = {
        OnCalendar = "02:00";
        RandomizedDelaySec = "1h";
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
      ];
    };
  };

  environment.systemPackages = [ pkgs.restic ];
}
