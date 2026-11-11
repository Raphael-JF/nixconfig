{...}:
{
  imports = [
    ./modules/os-shared.nix
    ./modules/dev
    ./modules/gaming.nix
    ./modules/nvidia.nix
    ./modules/backup-raid.nix
  ];
  raph.os-shared.device = "/dev/disk/by-uuid/EAF1-F867";
}
