{ config, pkgs, ... }:
{
    "$mod" = "SUPER";

    bind = [
    # navigateur
    "$mod, F, exec, firefox"

    # screenshot → copie directe dans le presse-papier
    ", Print, exec, grimblast copy area"

    # historique clipboard (menu)
    "$mod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

    # navigation workspaces
    "ALT, X, workspace, -1"
    "ALT, C, workspace, +1"

    # déplacer fenêtre entre workspaces
    "ALT SHIFT, X, movetoworkspace, -1"
    "ALT SHIFT, C, movetoworkspace, +1"
    ];

    exec-once = [
    # active le clipboard persist + historique
    "wl-paste --watch cliphist store"
    
    # barre (on la lance, config après)
    "waybar"
    ];

    # on limite à 2 workspaces visibles
    workspace = [
    "1, persistent:true"
    "2, persistent:true"
    ];
}