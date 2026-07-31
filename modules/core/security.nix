{ pkgs, ... }:
{
  security.sudo.wheelNeedsPassword = true;
  services.fprintd.enable = true; # Enable fingerprint authentication
  
  environment.systemPackages = with pkgs; [
    sops
    age
  ];

}
