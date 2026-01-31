{ variables, ... }:
{
  time.timeZone = variables.timezone;

  i18n = {
    defaultLocale = variables.locale;
    extraLocaleSettings = {
      LC_ADDRESS = variables.locale;
      LC_IDENTIFICATION = variables.locale;
      LC_MEASUREMENT = variables.locale;
      LC_MONETARY = variables.locale;
      LC_NAME = variables.locale;
      LC_NUMERIC = variables.locale;
      LC_PAPER = variables.locale;
      LC_TELEPHONE = variables.locale;
      LC_TIME = variables.locale;
    };
  };

  services.xserver.xkb = {
    layout = variables.keyboard.layout;
    variant = variables.keyboard.variant;
    options = variables.keyboard.options;
  };
}
