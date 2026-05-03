let 
    explorerSettings = import ./settings/explorer.nix;
    editorSettings = import ./settings/editor.nix;
in

{
    "telemetry.telemetryLevel" = "off";
    "security.workspace.trust.untrustedFiles" = "open";

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



    "workbench.panel.defaultLocation" = "right";

    "workbench.colorTheme" = "Solarized Light";
    "workbench.preferredLightColorTheme" = "Solarized Light";

    "window.menuBarVisibility" = "visible";

    "git.enableSmartCommit" = true;
    "git.confirmSync" = false;
    "git.autofetch" = true;
    "git.openRepositoryInParentFolders" = "always";



    "terminal.integrated.gpuAcceleration" = "off";
    "terminal.integrated.smoothScrolling" = true;
    "terminal.integrated.scrollback" = 10000;
    "terminal.integrated.persistentSessionScrollback" = 10000;

    "extensions.ignoreRecommendations" = true;



    "chat.viewSessions.orientation" = "stacked";
    "chat.disableAIFeatures" = false;

    "continue.enableTabAutocomplete" = false;
    "continue.showInlineTip" = false;

    "python.defaultInterpreterPath" = "/run/current-system/sw/bin/python";
}