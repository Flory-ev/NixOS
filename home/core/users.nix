{ pkgs, ... }:

{
  users.users.f = {
    isNormalUser = true;
    isSystemUser = false;
    shell = pkgs.zsh;
    group = "f";
		extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  users.groups.f = { };
}
