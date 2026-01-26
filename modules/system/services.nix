{ ... }:

{

  services = {
    flatpak = {
      enable = true;
      packages = [

      ];
      update.onActivation = true;
    };
  };

}
