{ pkgs, ... }:

{
  users.users.f = {
    isNormalUser = true;
    isSystemUser = false;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.zsh;
    group = "f";
  };

  users.groups.f = { };
}
