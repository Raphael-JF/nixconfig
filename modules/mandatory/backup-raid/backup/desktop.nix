{... }:
{
  sops.secrets.desktop-root = {
    sopsFile = ../../../secrets/keys/desktop-root.key.enc;
    format = "binary";
    mode = "0400";
  };
  
}
