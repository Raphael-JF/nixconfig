[   
    # Focus explorateur
    { command = "workbench.view.explorer"; key = "ctrl+shift+e"; }

    # Nouveau fichier / dossier
    { command = "explorer.newFile"; key = "ctrl+n"; when = "filesExplorerFocus && !inputFocus"; }
    { command = "explorer.newFolder"; key = "ctrl+shift+n"; when = "filesExplorerFocus && !inputFocus"; }

    # Renommer
    { command = "renameFile"; key = "f2"; when = "filesExplorerFocus && !inputFocus"; }

    # Supprimer
    { command = "deleteFile"; key = "delete"; when = "filesExplorerFocus && !inputFocus"; }

    # Copier / couper / coller
    { command = "filesExplorer.copy"; key = "ctrl+c"; when = "filesExplorerFocus && !inputFocus"; }
    { command = "filesExplorer.cut"; key = "ctrl+x"; when = "filesExplorerFocus && !inputFocus"; }
    { command = "filesExplorer.paste"; key = "ctrl+v"; when = "filesExplorerFocus && !inputFocus"; }

    # Refresh
    { command = "workbench.files.action.refreshFilesExplorer"; key = "f5"; when = "filesExplorerFocus"; }
]