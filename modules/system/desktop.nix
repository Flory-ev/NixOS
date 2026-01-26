{ pkgs, ... }:

{
  environment = {
    cosmic.excludePackages = with pkgs; [

    ];

    plasma6.excludePackages = with pkgs.kdePackages; [

    ];
  };

  services = {
    displayManager = {
      cosmic-greeter.enable = true;
      defaultSession = "plasma";
    };

    desktopManager = {
      cosmic.enable = true;
      plasma6.enable = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
    ];
  };
}
