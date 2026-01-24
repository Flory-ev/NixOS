{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

}
