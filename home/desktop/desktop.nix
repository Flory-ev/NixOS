{ pkgs, variables, ... }:
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
      defaultSession = variables.defaultSession;
    };

    desktopManager = {
      cosmic.enable = true;
      plasma6.enable = true;
    };
  };
}
