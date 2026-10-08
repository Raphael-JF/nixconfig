#!/usr/bin/env bash

REMOTE_SCRIPTS_DIR="~/IA/scripts"

log() {
    printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*"
}

error() {
    printf '[%s] ERROR: %s\n' "$(date '+%H:%M:%S')" "$*" >&2
}

tmpdir=$(mktemp -d)
candidates_fifo="$tmpdir/candidates"
winner_file="$tmpdir/winner"
winner_lock="$tmpdir/winner.lock"
producer_status="$tmpdir/producer.status"

mkfifo "$candidates_fifo"

cleanup() {
    rm -rf "$tmpdir"
}

trap cleanup EXIT

log "=== Recherche d'une machine disponible ==="
log "Recherche des candidates..."

# Tout le mécanisme de découverte tourne dans ce sous-shell.
(
    SUPERVISOR_PID=$$

    producer_pid=
    workers=()

    stop_all() {
        # Désactive le trap pour éviter de se rappeler lui-même.
        trap - TERM INT

        log "Machine utile trouvée, arrêt des recherches..."

        # Arrête whoAwake.
        if [ -n "$producer_pid" ]; then
            kill "$producer_pid" 2>/dev/null || true
        fi

        # Arrête tous les isUseful encore en cours.
        for pid in "${workers[@]}"; do
            kill "$pid" 2>/dev/null || true
        done

        # On attend leur disparition.
        wait 2>/dev/null || true

        exit 0
    }

    trap stop_all TERM INT

    # Producteur : les candidates arrivent directement dans le FIFO.
    (
        rc=0

        ssh travail64 "$REMOTE_SCRIPTS_DIR/whoAwake.sh" \
            > "$candidates_fifo" || rc=$?

        printf '%s\n' "$rc" > "$producer_status"
    ) &
    producer_pid=$!

    # Consommateur : chaque nouvelle ligne déclenche immédiatement
    # un isUseful en parallèle.
    while read -r ip hostname; do
        log "Candidate : $ip ($hostname)"

        (
            useful=$(
                ssh enseirb \
                    "$REMOTE_SCRIPTS_DIR/isUseful.sh $(printf '%q' "$ip") $(printf '%q' "$hostname")" \
                    2>/dev/null
            )

            if [ $? -ne 0 ]; then
                exit 0
            fi

            # mkdir est atomique : un seul worker peut gagner.
            if mkdir "$winner_lock" 2>/dev/null; then
                printf '%s\n' "$useful" > "$winner_file"

                # On prévient immédiatement le superviseur.
                kill -TERM "$SUPERVISOR_PID" 2>/dev/null || true
            fi
        ) &

        workers+=("$!")
    done < "$candidates_fifo"

    # whoAwake a terminé : il n'y aura plus de nouvelles candidates.
    producer_rc=0
    wait "$producer_pid" || producer_rc=$?
    printf '%s\n' "$producer_rc" > "$producer_status"

    # Toutes les candidates ont été testées.
    wait "${workers[@]}" 2>/dev/null || true
) &

discovery_pid=$!

# On laisse le superviseur :
# - soit se terminer parce qu'il a trouvé une machine ;
# - soit terminer après avoir épuisé toutes les candidates.
wait "$discovery_pid" 2>/dev/null || true

if [ ! -s "$winner_file" ]; then
    producer_rc=0

    if [ -s "$producer_status" ]; then
        read -r producer_rc < "$producer_status"
    fi

    if [ "$producer_rc" -ne 0 ]; then
        error "whoAwake.sh a échoué (code $producer_rc)"
    else
        error "Aucune machine disponible"
    fi

    exit 1
fi

useful=$(cat "$winner_file")
ip=$(awk '{print $1}' <<< "$useful")

log "Machine sélectionnée :"
log "  $useful"

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
