[
        # without anything : caracter by caracter
        { command = "cursorLeft"; key = "left"; when = "textInputFocus"; }
        { command = "cursorRight"; key = "right"; when = "textInputFocus"; }
        { command = "cursorUp"; key = "up"; when = "textInputFocus"; }
        { command = "cursorDown"; key = "down"; when = "textInputFocus"; }
        { command = "cursorHome"; key = "home"; when = "textInputFocus"; }
        { command = "cursorEnd"; key = "end"; when = "textInputFocus"; }

        # with shift
        { command = "cursorLeftSelect"; key = "shift+left"; when = "textInputFocus"; }
        { command = "cursorRightSelect"; key = "shift+right"; when = "textInputFocus"; }
        { command = "cursorUpSelect"; key = "shift+up"; when = "textInputFocus"; }
        { command = "cursorDownSelect"; key = "shift+down"; when = "textInputFocus"; }
        { command = "cursorHomeSelect"; key = "shift+home"; when = "textInputFocus"; }
        { command = "cursorEndSelect"; key = "shift+end"; when = "textInputFocus"; }

        #with ctrl : subword by subword
        { command = "cursorWordPartLeft"; key = "ctrl+left"; when = "textInputFocus"; }
        { command = "cursorWordPartRight"; key = "ctrl+right"; when = "textInputFocus"; }
        { command = "cursorDown"; key = "ctrl+down"; when = "textInputFocus"; }
        { command = "cursorHome"; key = "ctrl+home"; when = "textInputFocus"; }
        { command = "cursorEnd"; key = "ctrl+end"; when = "textInputFocus"; }

        # with ctrl+shift
        { command = "cursorWordPartLeftSelect"; key = "ctrl+shift+left"; when = "textInputFocus"; }
        { command = "cursorWordPartRightSelect"; key = "ctrl+shift+right"; when = "textInputFocus"; }
        { command = "cursorUpSelect"; key = "ctrl+shift+up"; when = "textInputFocus"; }
        { command = "cursorDownSelect"; key = "ctrl+shift+down"; when = "textInputFocus"; }
        { command = "cursorHomeSelect"; key = "ctrl+shift+home"; when = "textInputFocus"; }
        { command = "cursorEndSelect"; key = "ctrl+shift+end"; when = "textInputFocus"; }

        #with alt : word by word
        { command = "cursorWordLeft"; key = "alt+left"; when = "textInputFocus"; }
        { command = "cursorWordRight"; key = "alt+right"; when = "textInputFocus"; }
        { command = "cursorUp"; key = "alt+up"; when = "textInputFocus"; }
        { command = "cursorDown"; key = "alt+down"; when = "textInputFocus"; }
        { command = "cursorHome"; key = "alt+home"; when = "textInputFocus"; }
        { command = "cursorEnd"; key = "alt+end"; when = "textInputFocus"; }

        # with alt+shift
        { command = "cursorWordLeftSelect"; key = "alt+shift+left"; when = "textInputFocus"; }
        { command = "cursorWordRightSelect"; key = "alt+shift+right"; when = "textInputFocus"; }
        { command = "cursorUpSelect"; key = "alt+shift+up"; when = "textInputFocus"; }
        { command = "cursorDownSelect"; key = "alt+shift+down"; when = "textInputFocus"; }
        { command = "cursorHomeSelect"; key = "alt+shift+home"; when = "textInputFocus"; }
        { command = "cursorEndSelect"; key = "alt+shift+end"; when = "textInputFocus"; }


        # pattern navigation
        { command = "actions.find"; key = "ctrl+f"; when = "textInputFocus"; }
        { command = "editor.action.addSelectionToNextFindMatch"; key = "ctrl+d"; when = "textInputFocus"; }
        { command = "cursorUndo"; key = "ctrl+shift+d"; when = "textInputFocus"; }


        { command = "editor.action.changeAll"; key = "ctrl+shift+a"; when = "editorTextFocus"; }
        { command = "editor.action.selectAll"; key = "ctrl+a"; when = "textInputFocus"; }



        #menus
        { command = "workbench.action.navigateLast"; key = "alt+left"}
        { command = "workbench.action.navigateNext"; key = "alt+right"}


        
]