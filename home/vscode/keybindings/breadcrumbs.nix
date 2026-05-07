[
    # Breadcrumbs keybindings
    { command = "breadcrumbs.focusAndSelect"; key = "ctrl+e"; when = "breadcrumbsPossible && breadcrumbsVisible"; }
    { command = "breadcrumbs.focusNext"; key = "ctrl+right"; when = "breadcrumbsActive && breadcrumbsVisible"; }
    { command = "breadcrumbs.focusNext"; key = "right"; when = "breadcrumbsActive && breadcrumbsVisible"; }
    { command = "breadcrumbs.focusPrevious"; key = "ctrl+left"; when = "breadcrumbsActive && breadcrumbsVisible"; }
    { command = "breadcrumbs.focusPrevious"; key = "left"; when = "breadcrumbsActive && breadcrumbsVisible"; }
    { command = "breadcrumbs.revealFocused"; key = "ctrl+enter"; when = "breadcrumbsActive && breadcrumbsVisible"; }
    { command = "breadcrumbs.revealFocused"; key = "space"; when = "breadcrumbsActive && breadcrumbsVisible"; }
    { command = "breadcrumbs.revealFocusedFromTreeAside"; key = "ctrl+enter"; when = "breadcrumbsActive && breadcrumbsVisible && listFocus && !inputFocus && !treestickyScrollFocused"; }
    { command = "breadcrumbs.selectFocused"; key = "down"; when = "breadcrumbsActive && breadcrumbsVisible"; }
    { command = "breadcrumbs.selectFocused"; key = "enter"; when = "breadcrumbsActive && breadcrumbsVisible"; }
    { command = "breadcrumbs.toggleToOn"; key = "ctrl+shift+[IntlBackslash]"; when = "!config.breadcrumbs.enabled"; }

    { command = "breadcrumbs.selectFocused"; key = "enter"; when = "breadcrumbsActive && breadcrumbsVisible"; }

    { command = "breadcrumbs.focusNextWithPicker"; key = "ctrl+right"; when = "breadcrumbsActive && breadcrumbsVisible && listFocus && !inputFocus && !treestickyScrollFocused"; }
    { command = "breadcrumbs.focusPreviousWithPicker"; key = "ctrl+left"; when = "breadcrumbsActive && breadcrumbsVisible && listFocus && !inputFocus && !treestickyScrollFocused"; }
    { command = "breadcrumbs.selectEditor"; key = "escape"; when = "breadcrumbsActive && breadcrumbsVisible"; }
]
#- breadcrumbs.copyPath
#- breadcrumbs.toggle
#- breadcrumbs.toggleFromEditorTitle