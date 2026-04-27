let 
    explorerSettings = import ./settings/explorer.nix;
    editorSettings = import ./settings/editor.nix;
in

{
    "telemetry.telemetryLevel" = "off";
    "telemetry.enableTelemetry" = false;
    "telemetry.enableCrashReporter" = false;
    "security.workspace.trust.untrustedFiles" = "open";
    "editor.smoothScrolling" = true;
    "editor.unicodeHighlight.nonBasicASCII" = false;
    "editor.multiCursorModifier" = "ctrlCmd";
    "editor.renderWhitespace" = "none";

    "files.autoSave" = "afterDelay";
    "files.autoSaveDelay" = 5000;
}
//
    explorerSettings
//
    editorSettings
//
{
    "files.exclude" = {
    ".replit" = true;
    "replit.nix" = true;
    "venv" = true;
    };

    "remote.SSH.remotePlatform" = {
    "176.138.186.229" = "linux";
    "almapedago" = "linux";
    "192.168.137.98" = "linux";
    };

    "github.copilot.enable" = {
    "*" = true;
    "plaintext" = false;
    "markdown" = true;
    "cpp" = true;
    };

    # divers
    "editor.wordWrap" = "bounded";
    "editor.wrappingIndent" = "deepIndent";
    "editor.detectIndentation" = false;

    "editor.fontFamily" = "Consolas, Monocraft, 'Courier New', monospace";

    "workbench.editor.wrapTabs" = true;
    "workbench.editor.enablePreview" = false;

    "workbench.startupEditor" = "none";
    "workbench.panel.defaultLocation" = "right";

    "workbench.colorTheme" = "Solarized Light";
    "workbench.preferredLightColorTheme" = "Solarized Light";

    "window.menuBarVisibility" = "visible";

    "git.enableSmartCommit" = true;
    "git.confirmSync" = false;
    "git.autofetch" = true;
    "git.openRepositoryInParentFolders" = "always";

    "diffEditor.ignoreTrimWhitespace" = false;
    "diffEditor.renderSideBySide" = true;

    "editor.mouseWheelScrollSensitivity" = 2.5;
    "editor.minimap.enabled" = false;

    "terminal.integrated.gpuAcceleration" = "off";
    "terminal.integrated.smoothScrolling" = true;
    "terminal.integrated.scrollback" = 10000;
    "terminal.integrated.persistentSessionScrollback" = 10000;

    "extensions.ignoreRecommendations" = true;


    "editor.find.cursorMoveOnType" = false;

    "chat.viewSessions.orientation" = "stacked";
    "chat.disableAIFeatures" = false;

    "continue.enableTabAutocomplete" = false;
    "continue.showInlineTip" = false;

    "python.defaultInterpreterPath" = "/run/current-system/sw/bin/python";
}