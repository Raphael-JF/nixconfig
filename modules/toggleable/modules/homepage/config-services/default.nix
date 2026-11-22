{ globals, ...}:
{
  imports = [ ./icloud-backup.nix ];

  services.homepage-dashboard.services = [
    { 
      "Médias" = [
        {
          Nextcloud = {
            icon = "nextcloud.png";
            href = "https://files.${globals.server-url}/apps/files/files";
            container = "nextcloud";
            description = "Stockage de fichiers cloud privé";
            widget = {
              type = "nextcloud";
              url = "https://files.${globals.server-url}";
              user = "raph";
              password = "{{NEXTCLOUD_PASSWORD}}";
              fields = [ "freespace" "numfiles" "numshares" ];
           };
          };
        }
        {
          Recettes = {
            href = "https://recipiz.${globals.server-url}";
            siteMonitor = "https://recipiz.${globals.server-url}";
          };
        }
      ];
    }
  ];
}
