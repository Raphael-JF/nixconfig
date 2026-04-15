{
    "$mod" = "SUPER";

    bind = [
    # navigateur
    "$mod, F, exec, firefox"

    # terminal
    "$mod, T, exec, kitty"

    # screenshot → copie directe dans le presse-papier
    "$mod SHIFT, S, exec, grimblast --notify copy area"

    # historique clipboard (menu)
    "$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

    # navigation workspaces
    "ALT, X, workspace, -1"
    "ALT, C, workspace, +1"

    # déplacer fenêtre entre workspaces
    "ALT SHIFT, X, movetoworkspace, -1"
    "ALT SHIFT, C, movetoworkspace, +1"

    # fermer une fenêtre
    "ALT, F4, exec, hyprctl dispatch killactive"

    # fermer la session
    "$mod, M, exit"
    ];

    exec-once = [
    "wl-paste --type text --watch cliphist store"
    "wl-paste --type image --watch cliphist store"
    # barre (on la lance, config après)
    "waybar"
    ];

    # on limite à 2 workspaces visibles
    workspace = [
    "1, persistent:true"
    "2, persistent:true"
    ];

    

    monitor = [
        ", preferred, auto, 1"
    ];
}