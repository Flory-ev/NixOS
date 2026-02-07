{
  config,
  lib,
  pkgs,
  ...
}:

{
  users.users.f = {
    description = "F";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "audio"
      "docker"
      "input"
      "libvirtd"
      "networkmanager"
      "storage"
      "video"
      "wheel"
    ];
  };
}
