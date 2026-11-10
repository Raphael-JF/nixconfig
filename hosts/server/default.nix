{ pkgs, config, ... }:

{
  imports = [

    ./hardware-configuration.nix
    # ./disko.nix

    ../../modules
  ];

  boot.initrd.luks.devices.cryptroot.device =
    "/dev/disk/by-uuid/2bd031fa-cdcf-4beb-a1e1-2c60bd82ec1e";


  sops.secrets.cryptssd-key = {
    sopsFile = ../../secrets/cryptssd.key.enc;
    format = "binary";
  };

  systemd.services.unlock-cryptssd = {
    description = "Unlock LUKS SSD";

    requires = [ "sops-install-secrets.service" ];
    after = [ "sops-install-secrets.service" ];

    path = [ pkgs.cryptsetup pkgs.lvm2 ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      cryptsetup open \
        /dev/disk/by-uuid/1a09185b-c2e3-4e1b-89b6-fd67b04cee7e \
        cryptssd \
        --key-file ${config.sops.secrets.cryptssd-key.path}

      vgchange -ay ssd
    '';
  };


  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4085019f-ebea-4e8b-9128-c74ddf0b090e";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/000D-3640";
    fsType = "vfat";
  };

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/2b9fa347-843d-4393-a58f-b47df58aa72f";
    fsType = "btrfs";
    options = [
      "noatime"
      "noauto"
      "nofail"
      "x-systemd.wanted-by=multi-user.target"
      "x-systemd.requires=unlock-cryptssd.service"
      "x-systemd.after=unlock-cryptssd.service"
    ];
  };

  fileSystems."/torrents" = {
    device = "/dev/disk/by-uuid/620a1c05-006d-4a6a-b55a-9633023c9e78";
    fsType = "ext4";
    options = [
      "noatime"
      "noauto"
      "nofail"
      "x-systemd.wanted-by=multi-user.target"
      "x-systemd.requires=unlock-cryptssd.service"
      "x-systemd.after=unlock-cryptssd.service"
    ]; 
  };

  swapDevices = [
    {
      device = "/dev/pool/swap";
      randomEncryption.enable = true;
    }
  ];
  
  services.icloudBackup = {
    enable = true;
    instances.raph = {
      savePath = "/data/nextcloud/data/raph/files/Photos";
      appleID = "poweraphael2@gmail.com";
    };
  };

  system.stateVersion = "26.05";
}
