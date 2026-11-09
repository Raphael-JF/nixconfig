{...}:
{
  imports = [
    ./modules/os-shared.nix
    ./modules/dev
    ./modules/windowManager
    ./modules/gaming.nix
  ];
  raph.os-shared.device = "/dev/disk/by-uuid/81D8-6A18";
}
