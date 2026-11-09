{...}:
{
  imports = [
    ./modules/os-shared.nix
    ./modules/dev
  ];
  raph.os-shared.device = "/dev/disk/by-uuid/726D-7F83";
}
