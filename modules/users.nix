{ pkgs, ... }:
{
  # --- Users ---
  users.users.f = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "input"
      "kvm"
      "libvirtd"
      "networkmanager"
      "video"
      "wheel"
    ];
  };
}
