{ ... }:

{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.tmp.cleanOnBoot = true;


  boot.initrd.systemd = {
    enable = true;
    services."dev-pool-root.device".unitConfig = {
      JobTimeoutSec = "infinity";
    };
  };
}
