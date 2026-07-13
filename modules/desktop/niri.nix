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
    xwayland-satellite # Required for niri's built-in Xwayland integration
    # (Steam, and any X11 app/game, needs this in $PATH — niri auto-spawns
    # it on demand since 25.08, but only if it can find the binary)
  ];
}
