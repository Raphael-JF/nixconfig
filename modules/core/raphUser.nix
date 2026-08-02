
{ config, ... }:

{
  users.users.raph = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.raphPassword.path;

    extraGroups = [
      "wheel"
      "docker"
    ];

    openssh.authorizedKeys.keys = [
      builtins.readFile config.sops.secrets.desktop.public.path
      builtins.readFile config.sops.secrets.laptop.public.path
      builtins.readFile config.sops.secrets.server.public.path
      builtins.readFile config.sops.secrets.iphone.public.path
    ];

  };

}
