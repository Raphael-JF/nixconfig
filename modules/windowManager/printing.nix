{ pkgs, ... }:
{
  services.printing.enable = true;
  services.ipp-usb.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];
}
