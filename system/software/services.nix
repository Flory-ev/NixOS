{ ... }:

{
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    flatpak = {
      enable = true;
    };

    fwupd = {
      enable = true;
    };

    printing = {
      enable = true;
    };
  };
}
