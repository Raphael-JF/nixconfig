{ ... }:
{
  services.healthchecks = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = 8000;
    settings = {
      SITE_ROOT = "http://127.0.0.1:8000";
      ALLOWED_HOSTS = [ "127.0.0.1" ];
      SECRET_KEY_FILE = "/etc/healthchecks/secret-key";
    };
  };
}
