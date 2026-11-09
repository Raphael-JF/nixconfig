{...}:
{
  imports = [
    ./modules/os-shared.nix
    ./modules/dev
    ./modules/windowManager
  ];
  raph.os-shared.device = "/dev/disk/by-uuid/726D-7F83";
}
