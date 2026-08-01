{ pkgs, hostname, config, lib, ... }:
let
  hosts = [ "laptop" "desktop" "server" "iphone" ];

  mkPublicKey = host: {
    mode = "644";
    owner = config.users.users.${hostname}.name;
    group = config.users.users.${hostname}.group;
    path = lib.mkIf (host == hostname)
      "/home/${config.users.users.${hostname}.name}/.ssh/${host}.pub";
  };
in

{
  security.sudo.wheelNeedsPassword = true;
  services.fprintd.enable = true; # Enable fingerprint authentication
  
  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat= "yaml";
  
  sops.age.keyFile = "/home/${hostname}/.config/sops/age/keys.txt";

  sops.secrets =
    lib.genAttrs
      (map (h: "ssh/${h}/public") hosts)
      (name: mkPublicKey (builtins.elemAt (lib.splitString "/" name) 1))
    //
    {
      "ssh/${hostname}/private" = {
        mode = "600";
        owner = config.users.users.${hostname}.name;
        group = config.users.users.${hostname}.group;
        path = "/home/${hostname}/.ssh/${hostname}";
      };
    };
}
