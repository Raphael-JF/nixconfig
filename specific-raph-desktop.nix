{ config, pkgs, lib, ... }:

{
  # ===== DEVICE-SPECIFIC CONFIG =====
  raph.hostType = "desktop";

  
  # ===== NETWORK =====
  networking.hostName = "raph-desktop";

  services.zerotierone.enable = true;

  # ===== NVIDIA GRAPHICS =====
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;  # see the note above
  hardware.nvidia.modesetting.enable = true; 
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "580.159.03";
    sha256_64bit = "sha256-MshdmbD2QMlQH2GzndrSCP0CiNAVxPvF/QQ1wHeD+nc=";
    sha256_aarch64 = "sha256-MshdmbD2QMlQH2GzndrSCP0CiNAVxPvF/QQ1wHeD+nc=";
    openSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
    settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
    persistencedSha256 = lib.fakeSha256;
  };
  hardware.nvidia.powerManagement.enable = true;
}
