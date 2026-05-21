{ pkgs, ... }:
{
  # --- Fonts ---
  fonts.packages = with pkgs; [
    fira-code
    font-awesome
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
