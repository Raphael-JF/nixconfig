{...}:
{
  imports = [
    # ./modules/backup-usb
    ./modules/homepage
    ./modules/icloud-backup
    ./modules/nextcloud
    ./modules/duckdns
    ./modules/tv

    ./modules/sgbd

    ./modules/postgresql.nix
    ./modules/recipiz.nix
    ./modules/no-suspend.nix
  ];
}
