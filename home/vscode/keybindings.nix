let
    disableKeybindings = import ./keybindings/disable.nix;
    cursorNavigationKeybindings = import ./keybindings/cursor/navigation.nix;
    cursorTypingKeybindings = import ./keybindings/cursor/typing.nix;
    workspaceKeybindings = import ./keybindings/workbench.nix;
    enterKeybindings = import ./keybindings/enter.nix;


in


[
    { command = "editor.action.addCommentLine"; key = "ctrl+3"; when = "editorTextFocus && !editorReadonly"; }
    { command = "editor.action.removeCommentLine"; key = "ctrl+shift+3"; when = "editorTextFocus && !editorReadonly"; }
    { command = "editor.action.changeAll"; key = "ctrl+shift+a"; when = "editorTextFocus && !editorReadonly"; }
    { command = "code-runner.run"; key = "f5"; }
    { command = "workbench.action.duplicateWorkspaceInNewWindow"; key = "ctrl+shift+n"; }
    { command = "workbench.action.toggleLightDarkThemes"; key = "ctrl+shift+m"; }
    { command = "git.checkout"; key = "ctrl+alt+d"; }
    { command = "workbench.action.zoomOut"; key = "ctrl+6"; }
    { command = "overleaf-workshop.compileManager.compile"; key = "ctrl+c ctrl+enter"; when = "editorTextFocus && overleaf-workshop.activateCompile && resourceExtname == '.tex' || editorTextFocus && resourceExtname == '.tex' && resourceScheme == 'overleaf-workshop' || editorTextFocus && overleaf-workshop.activateCompile && resourceExtname == '.tex' && resourceScheme == 'overleaf-workshop'"; }
    { command = "cursorUndo"; key = "ctrl+shift+d"; when = "textInputFocus"; }
    { command = "editor.action.addSelectionToPreviousFindMatch"; key = "ctrl+q"; }
    { command = "welcome.showNewFileEntries"; key = "ctrl+n"; }
    { command = "latex-workshop.close-env"; key = "ctrl+space"; }
    { command = "workbench.action.zoomIn"; key = "ctrl+shift+oem_plus"; }
    { command = "workbench.action.focusNextPart"; key = "ctrl+g"; }
    { command = "workbench.action.focusPreviousPart"; key = "ctrl+t"; }
    { command = "github.copilot.completions.toggle"; key = "ctrl+oem_7"; }
    { command = "github.copilot.acceptCursorPanelSolution"; key = "alt+oem_7"; when = "github.copilot.panelVisible && activeWebviewPanelId == 'GitHub Copilot Suggestions'"; }
    { command = "editor.action.inlineSuggest.commit"; key = "f1"; when = "inlineEditIsVisible && tabShouldAcceptInlineEdit && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible || inlineEditIsVisible && inlineSuggestionVisible && tabShouldAcceptInlineEdit && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible || inlineSuggestionHasIndentationLessThanTabSize && inlineSuggestionVisible && !editor.hasSelection && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible || inlineEditIsVisible && inlineSuggestionHasIndentationLessThanTabSize && inlineSuggestionVisible && !editor.hasSelection && !editorHoverFocused && !editorTabMovesFocus && !suggestWidgetVisible"; }
    { command = "editor.action.inlineSuggest.commit"; key = "f1"; when = "inInlineEditsPreviewEditor"; }
    { command = "github.copilot.chat.completions.toggle"; key = "ctrl+[Backquote]"; when = "github.copilot.activated && github.copilot.extensionUnification.activated"; }
] ++ disableKeybindings ++ cursorNavigationKeybindings ++ cursorTypingKeybindings ++ workspaceKeybindings ++ enterKeybindings