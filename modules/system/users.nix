{ pkgs, ... }:
{
  # --- Users ---
  users.users.f = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "input"
      "networkmanager"
      "video"
      "wheel"
    ];
  };
}
