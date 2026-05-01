{ config, pkgs, lib, ... }:

{
  # ===== NETWORK =====
  networking.hostName = "raph-desktop";

  # ===== NVIDIA GRAPHICS =====
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    # IMPORTANT pour GTX 1050 (Pascal)
    open = false;

    nvidiaSettings = true;

    # driver classique
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
}
