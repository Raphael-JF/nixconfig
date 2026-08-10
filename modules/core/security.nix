{ pkgs, hostname, config, lib, ... }:
let
  hosts = [ "laptop" "desktop" "server" "iphone" ];

  mkPublicKey = host: {
    mode = "644";
    owner = config.users.users.raph.name;
    group = config.users.users.raph.group;
    path = lib.mkIf (host == hostname)
      "/home/raph/.ssh/${host}.pub";
  };
in

{
  security.sudo.wheelNeedsPassword = true;
  services.fprintd.enable = true; # Enable fingerprint authentication
  
  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  sops.defaultSopsFile = ../../secrets/passwords.yaml;
  sops.defaultSopsFormat= "yaml";
  
  # sops.age.keyFile = "/home/raph/.config/sops/age/keys.txt";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets =
    lib.genAttrs
      (map (h: "ssh/${h}/public") hosts)
      (name: mkPublicKey (builtins.elemAt (lib.splitString "/" name) 1))
    //
    {
      "ssh/${hostname}/private" = {
        mode = "600";
        owner = config.users.users.raph.name;
        group = config.users.users.raph.group;
        path = "/home/raph/.ssh/${hostname}";
      };
    }
    //
    {
      raphPassword = {
        neededForUsers = true;
        mode = "600";
        owner = "root";
        group = "root";
      };
      nextcloudAdminPassword = {
        mode = "600";
        owner = "root";
        group = "root";
      };
    };
}
