{ config, lib, pkgs, ... }:

{
  users.users.f = {
    isNormalUser = true;
    home = "/home/f";
    shell = pkgs.zsh;
    extraGroups = [ "kvm" "libvirtd" "networkmanager" "wheel" ];
    initialHashedPassword = "$y$j9T$8T41ml.08LAvNa02/0eUV.$uLjb1z6VegRqepV9Dr02j8mopvUJJag/pd9I9oBr258";
  };
}
