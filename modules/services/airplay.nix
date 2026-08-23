{ config, lib, pkgs, ... }:

let
  cfg = config.services.airplay;
in
{
  options.services.airplay = {
    enable = lib.mkEnableOption "AirPlay audio receiver";

    name = lib.mkOption {
      type = lib.types.str;
      default = "Cuisine";
      description = "Name displayed by AirPlay clients.";
    };

    alsaDevice = lib.mkOption {
      type = lib.types.str;
      default = "hw:0,0";
      description = "ALSA playback device used by Shairport Sync.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.shairport-sync = {
      enable = true;
      openFirewall = true;

      settings = {
        general = {
          name = cfg.name;
          output_backend = "alsa";
        };

        alsa = {
          name = cfg.alsaDevice;
        };
      };
    };
  };
}
