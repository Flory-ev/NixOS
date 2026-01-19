{ config, lib, pkgs, ... }:

{
  users.users.f = {
  home = "/home/f";
  isNormalUser = true;
  extraGroups = [ "kvm" "libvirtd" "networkmanager" "wheel" ];
  shell = pkgs.zsh;
  initialHashedPassword = "$y$j9T$8T41ml.08LAvNa02/0eUV.$uLjb1z6VegRqepV9Dr02j8mopvUJJag/pd9I9oBr258";
};
