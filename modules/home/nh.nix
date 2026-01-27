{ user, ... }:

{
  programs.nh = {
    enable = true;
    flake = "/home/${user}/nixos";
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
  };
}
