REMOTE_SCRIPTS_DIR="~/IA/scripts"

log() {
    printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*"
}

error() {
    printf '[%s] ERROR: %s\n' "$(date '+%H:%M:%S')" "$*" >&2
}

log "=== Recherche d'une machine disponible ==="

log "Génération de la liste des candidates..."
if ! ssh almapedago "$REMOTE_SCRIPTS_DIR/whoAwake.sh > $REMOTE_SCRIPTS_DIR/candidates.txt"; then
    error "Impossible de générer candidates.txt"
    exit 1
fi

log "Analyse des candidates..."
if ! ssh enseirb 'bash ~/IA/scripts/analyseCandidates.sh' \
    > /tmp/useful_candidate.txt; then
    error "Échec de l'analyse des candidates"
    exit 1
fi
ip=$(awk '{ print $1 }' /tmp/useful_candidate.txt)

if [ -z "$ip" ]; then
    error "Aucune machine disponible"
    exit 1
fi

log "Machine sélectionnée :"
cat /tmp/useful_candidate.txt

log "Démarrage de l'IA sur $ip..."
if ! TERM=xterm-256color ssh -t \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o LogLevel=ERROR \
    -J enseirb \
    -L 1234:localhost:1234 \
    "rjontef@$ip" \
    "$REMOTE_SCRIPTS_DIR/startIA.sh"
then
    error "Le démarrage de l'IA a échoué"
fi

log "Connexion terminée, arrêt de l'IA sur $ip..."

if ! ssh -t \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    -o LogLevel=ERROR \
    -J enseirb \
    "rjontef@$ip" \
    "$REMOTE_SCRIPTS_DIR/stopIA.sh"
then
    error "L'arrêt de l'IA a échoué"
    exit 1
fi

log "IA arrêtée."
log "=== Terminé ==="
