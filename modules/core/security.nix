{ pkgs, hostname,  ... }:
{
  security.sudo.wheelNeedsPassword = true;
  services.fprintd.enable = true; # Enable fingerprint authentication
  
  environment.systemPackages = with pkgs; [
    sops
    age
  ];

    sops.defaultSopsFile = ./secrets/secrets.yaml;
    sops.defaultSopsFormat= "json";
    
    sops.age.keyFile = "/home/${hostname}/.config/sops/age/keys.txt";
}
