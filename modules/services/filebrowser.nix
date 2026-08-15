{ ... }:
{
  services.filebrowser = {
    enable = true;

    settings = {
      port = 8080;
      address = "127.0.0.1";
      root = "/data/files";
      database = "/data/filebrowser.db";
    };
  };
}
