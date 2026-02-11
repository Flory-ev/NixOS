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
      "networkmanager"
      "storage"
      "video"
      "wheel"
    ];
  };
}
