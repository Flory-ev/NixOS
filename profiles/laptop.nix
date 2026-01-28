{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./base.nix
    ../modules/system/audio.nix
    ../modules/system/graphics.nix
  ];

  programs.dconf.enable = true;

  # Шрифты
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
  ];

  # Управление питанием для ноутбука
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # Пороги зарядки батареи (продлевает жизнь батареи)
      START_CHARGE_THRESH_BAT0 = 20;
      STOP_CHARGE_THRESH_BAT0 = 80;

      # Отключение USB в режиме батареи для экономии
      USB_AUTOSUSPEND = 1;

      # Управление дисками
      DISK_DEVICES = "nvme0n1 sda";
      DISK_APM_LEVEL_ON_AC = "254 254";
      DISK_APM_LEVEL_ON_BAT = "128 128";
    };
  };

  # Автоматическое управление частотой CPU
  services.auto-cpufreq.enable = true;

  # Управление температурой (для Intel процессоров)
  services.thermald.enable = true;

  # Поддержка тачпада
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
      accelSpeed = "0.3";
      clickMethod = "clickfinger";
    };
  };

  # Управление яркостью экрана
  programs.light.enable = true;

  # Добавление пользователя в группу video для управления яркостью
  users.users = lib.mkDefault {
    # Это нужно будет адаптировать под ваше имя пользователя
    # или можно использовать в конкретной конфигурации хоста
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;

  # Поддержка сканера отпечатков пальцев (если есть)
  # services.fprintd.enable = true;

  # Ускорение графики для ноутбуков
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Автоматическое монтирование USB и внешних дисков
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Утилиты для ноутбука
  environment.systemPackages = with pkgs; [
    powertop # Мониторинг энергопотребления
    acpi # Информация о батарее и температуре
    brightnessctl # Управление яркостью
    usbutils # Утилиты для USB
  ];

  # Suspend при закрытии крышки
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "suspend";

    extraConfig = ''
      HandlePowerKey=suspend
      IdleAction=suspend
      IdleActionSec=30min
    '';
  };

  # Включение firmware для Wi-Fi и других устройств
  hardware.enableRedistributableFirmware = true;

  # Оптимизация для SSD/NVMe (если используется)
  services.fstrim.enable = true;
}
