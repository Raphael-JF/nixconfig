{ pkgs, ... }:

{
  time.timeZone = "Europe/Paris";

  i18n = 
    {
      defaultLocale = "en_US.UTF-8";
     extraLocaleSettings.LC_ALL = "en_US.UTF-8"; # This overrides all other LC_* settings.
    };

  console.keyMap = "fr";

  environment.systemPackages = with pkgs; [
    kitty.terminfo
  ];
}
