{ globals, ...}:
{
  imports = [ ./icloudBackup.nix ];

  services.homepage-dashboard.services = [
    { 
      Services = [
        {
          Fichiers = {
            icon = "nextcloud.png";
            href = "https://files.${globals.server-url}/apps/files/files";
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
