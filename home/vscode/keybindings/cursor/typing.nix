[        
    { command = "undo"; key = "ctrl+z"; when = "textInputFocus && !editorReadonly"; }
    { command = "redo"; key = "ctrl+shift+z"; when = "textInputFocus && !editorReadonly"; }

    { command = "deleteLeft"; key = "backspace"; when = "textInputFocus && !editorReadonly"; }
    { command = "deleteRight"; key = "delete"; when = "textInputFocus && !editorReadonly"; }
    { commmand = "deleteWordLeft"; key = "ctrl+backspace"; when = "textInputFocus && !editorReadonly"; }
    { command = "deleteWordRight"; key = "ctrl+delete"; when = "textInputFocus && !editorReadonly"; }

    { commmand = "commentLine"; key = "ctrl+3"; when = "editorTextFocus && !editorReadonly"; }
    { command = "editor.action.removeCommentLine"; key = "ctrl+shift+3"; when = "editorTextFocus && !editorReadonly"; 
    }

    { command = "tabulate"; key = "tab"; when = "textInputFocus && !editorReadonly"; }
    { command = "outdent"; key = "shift+tab"; when = "textInputFocus && !editorReadonly"; }

            { command = "editor.action.clipboardCopyAction"; key = "ctrl+c"; when = "textInputFocus"; }
        { command = "editor.action.clipboardCutAction"; key = "ctrl+x"; when = "textInputFocus && !editorReadonly"; }
        { command = "editor.action.clipboardPasteAction"; key = "ctrl+v"; when = "textInputFocus && !editorReadonly"; }
]