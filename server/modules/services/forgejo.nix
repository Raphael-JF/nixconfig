{ config, pkgs, ... }:

{
  services.forgejo = {
    enable = true;
    # Configuration de base
    #host = "0.0.0.0";  # Écoute sur toutes les interfaces
    port = 3000;       # Port par défaut pour Forgejo
    protocol = "http"; # ou "https" si tu utilises un reverse proxy avec SSL

    # Configuration de la base de données (SQLite par défaut, mais PostgreSQL est recommandé)
    database = {
      type = "postgres";
      path = "/var/lib/forgejo/forgejo.db";
    };

    # Configuration du stockage (répertoires pour les dépôts, LFS, etc.)
    storage = {
      repositories = "/var/lib/forgejo/repositories";
      lfs = "/var/lib/forgejo/lfs";
    };

    # Configuration du reverse proxy (si tu utilises Nginx ou Caddy)
    reverseProxy = {
      enable = true;
      type = "nginx"; # ou "caddy" si tu préfères
    };

    # Configuration de l'URL publique (remplace par ton domaine ou IP locale)
    domain = "forgejo.tondomaine.local";
    sshDomain = "forgejo.tondomaine.local";

    # Configuration SSH (optionnel, mais utile pour les clés SSH)
    ssh = {
      enable = true;
      port = 2222; # Port personnalisé pour éviter les conflits avec le SSH système
    };

    # Configuration SMTP (optionnel, pour les notifications par email)
    mail = {
      enabled = false; # Désactivé par défaut
      # host = "smtp.tondomaine.local";
      # port = 587;
      # username = "user";
      # password = "password";
      # from = "forgejo@tondomaine.local";
    };

    # Configuration supplémentaire (optionnelle)
    extraConfig = ''
      [repository]
      DEFAULT_PUSH_CREATE_PRIVATE = true
      [service]
      DISABLE_REGISTRATION = false
    '';
  };

  # Créer un utilisateur système pour Forgejo (optionnel, mais recommandé)
  users.users.forgejo = {
    isSystemUser = true;
    group = "forgejo";
    home = "/var/lib/forgejo";
    shell = pkgs.bash;
  };

  # Créer les répertoires nécessaires
  system.activationScripts.setupForgejoDirs = ''
    mkdir -p /var/lib/forgejo/{repositories,lfs}
    chown -R forgejo:forgejo /var/lib/forgejo
  '';
}
