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

          appleID = lib.mkOption {
            type = lib.types.str;
            description = "Apple ID";
          };
        };
      });

      default = {};
    };
  };
}
