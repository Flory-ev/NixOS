{ pkgs, ... }:
{
  # --- Packages ---
  environment.systemPackages = with pkgs; [
    curl
    nixfmt
    wget
  ];
}
