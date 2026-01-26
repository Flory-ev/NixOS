{ ... }:

{

  services = {
    flatpak = {
      enable = true;
      packages = [

      ];
      update.onActivation = true;
    };

    printing = {
      enable = true;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    fwupd = {
      enable = true;
    };
  };

}
