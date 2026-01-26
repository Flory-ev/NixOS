{ pkgs, user, ... }:

{
  users.users.${user} = {
    home = "/home/${user}";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "kvm"
      "libvirtd"
      "networkmanager"
      "wheel"
    ];
  };
}