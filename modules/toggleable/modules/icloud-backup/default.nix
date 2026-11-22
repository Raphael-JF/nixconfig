{ lib, ... }:
{
  imports = [
    # ./init.nix
    ./backup.nix
    ./auth.nix
    ./users.nix
  ];

  options.services.icloudBackup = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable iCloud backup service";
    };
    instances = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          savePath = lib.mkOption {
            type = lib.types.path;
            description = "Path to save the iCloud backup";
          };

          appleID = lib.mkOption {
            type = lib.types.str;
            description = "Apple ID";
          };
          healthchecksUuid = lib.mkOption {
            type = lib.types.nonEmptyStr;
            description = "UUID du check Healthchecks de ce profil iCloud.";
          };
        };
      });

      default = {};
    };
  };
}
