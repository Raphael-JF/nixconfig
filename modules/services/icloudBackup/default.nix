{ lib, ... }:
{
  imports = [
    ./backup.nix
    ./auth.nix
    ./users.nix
  ];

  options.services.icloudBackup = {
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
