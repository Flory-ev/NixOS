{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    waybar # Status bar
    fuzzel # App launcher
    mako # Notifications
    awww # Wallpaper daemon
    swaylock # Screen locker
    brightnessctl # Brightness control (for keybinds)
    playerctl # Media key support
    wl-clipboard # Clipboard support
    grim # Screenshot tool
    slurp # Region selection
  ];
}
