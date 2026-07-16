{ pkgs, ... }:
{
  # --- Packages ---
  environment.systemPackages = with pkgs; [
    nixfmt
  ];
}
