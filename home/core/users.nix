{ pkgs, variables, ... }:

{
  users.users.${variables.username} = {
    isNormalUser = true;
    isSystemUser = false;
    shell = pkgs.zsh;
    group = variables.username;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  users.groups.${variables.username} = { };
}
