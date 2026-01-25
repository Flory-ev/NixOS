{ pkgs, user, ... }:

{
  users.users.${user} = {
    home = "/home/${user}";
    isNormalUser = true;
    shell = pkgs.zsh;
    initialHashedPassword = "$y$j9T$8T41ml.08LAvNa02/0eUV.$uLjb1z6VegRqepV9Dr02j8mopvUJJag/pd9I9oBr258";
    extraGroups = [
      "kvm"
      "libvirtd"
      "networkmanager"
      "wheel"
    ];
  };

}
