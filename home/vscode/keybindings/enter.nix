# This file contains keybindings related to the "enter" key. It is not meant to be kept but this is a good way too have a look up to all different menus and widgets.
[
    { command = "inlineChat.submitInput"; key = "enter"; when = "inlineChatHasEditsAgent && inlineChatInputHasText && inlineChatInputWidgetFocused && inlineChatFileBelongsToChat"; }
    { command = "editor.action.nextMatchFindAction"; key = "enter"; when = "editorFocus && findInputFocussed"; }
    { command = "workbench.action.chat.submit"; key = "enter"; when = "chatInputHasText && chatSessionOptionsValid && inChatInput && !chatSessionRequestInProgress && !withinEditSessionDiff"; }
    { command = "acceptRenameInput"; key = "enter"; when = "editorFocus && renameInputVisible && !isComposing"; }
    { command = "breadcrumbs.selectFocused"; key = "enter"; when = "breadcrumbsActive && breadcrumbsVisible"; }
    { command = "iconSelectBox.selectFocused"; key = "enter"; when = "iconSelectBoxFocus"; }
    { command = "list.select"; key = "enter"; when = "listFocus && !inputFocus && !treestickyScrollFocused"; }
    { command = "quickInput.accept"; key = "enter"; when = "inQuickInput && !isComposing && quickInputType != 'quickWidget'"; }
    { command = "search.action.openResult"; key = "enter"; when = "fileMatchOrMatchFocus && searchViewletVisible"; }
    { command = "explorer.openAndPassFocus"; key = "enter"; when = "filesExplorerFocus && foldersViewVisible && !explorerResourceIsFolder && !inputFocus"; }
    { command = "list.stickyScrollselect"; key = "enter"; when = "treestickyScrollFocused"; }
    { command = "acceptSelectedCodeAction"; key = "enter"; when = "codeActionMenuVisible"; }
]