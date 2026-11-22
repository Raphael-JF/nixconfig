{ globals, ...}:
{
  services.homepage-dashboard.services = [
    { 
      State-group = [
        { 
          "Sauvegardes iCloud" = [
            {
              raph = {
                icon = "mdi-camera";
                widget = {
                  type = "healthchecks";
                  url = "http://127.0.0.1:8000";
                  key = "{{HOMEPAGE_VAR_HEALTHCHECKS_API_KEY}}";
                  uuid = "UUID-DU-CHECK-ICLOUD";
                };
              };
            }
          ];
        }
      ];
      Services-group = [
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
