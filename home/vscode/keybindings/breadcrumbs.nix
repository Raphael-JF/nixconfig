[
    # Breadcrumbs keybindings
    { command = "breadcrumbs.focusAndSelect"; key = "ctrl+e"; when = "breadcrumbsPossible && breadcrumbsVisible"; }
    { command = "breadcrumbs.focusNext"; key = "ctrl+right"; when = "breadcrumbsActive && breadcrumbsVisible"; }
    { command = "breadcrumbs.focusNext"; key = "right"; when = "breadcrumbsActive && breadcrumbsVisible"; }
    { command = "breadcrumbs.focusPrevious"; key = "left"; when = "breadcrumbsActive && breadcrumbsVisible"; }
    { command = "breadcrumbs.revealFocused"; key = "ctrl+enter"; when = "breadcrumbsActive && breadcrumbsVisible"; }
    { command = "breadcrumbs.selectFocused"; key = "enter"; when = "breadcrumbsActive && breadcrumbsVisible"; }

]
#- breadcrumbs.copyPath
#- breadcrumbs.toggle
#- breadcrumbs.toggleFromEditorTitle