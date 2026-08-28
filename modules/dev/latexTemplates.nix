{ pkgs, inputs, lib,...}:

let
  latexTemplates = inputs.latex-templates;
  templates = [
    "algonum"
    "cours"
    "alveus"
    "graphes"
    "projet"
  ];

  import-templates = pkgs.writeShellApplication {
    name = "import-templates";

    runtimeInputs = with pkgs; [
      coreutils
    ];

    text = ''
      set -euo pipefail

      case "$#" in
        0|1)
          echo "Usage: import-templates <template> <destination>"
          exit 1
          ;;
      esac

      TEMPLATE="$1"
      DEST="$2"

      case "$TEMPLATE" in
        ${lib.concatStringsSep "|" templates})
          ;;
        *)
          echo "❌ Template invalide : $TEMPLATE"
          exit 1
          ;;
      esac

      mkdir -p "$DEST"

      cp -r "${latexTemplates}/$TEMPLATE" "$DEST/"
      cp -r "${latexTemplates}/backend" "$DEST/"
    '';
  };

  templateCompletion = lib.concatStringsSep " " templates;
in
{
  environment.systemPackages = [
    import-templates
  ];
  programs.bash.interactiveShellInit = ''
    _import_templates() {
      local cur="''${COMP_WORDS[COMP_CWORD]}"

      if (( COMP_CWORD == 1 )); then
        COMPREPLY=($(compgen -W "${templateCompletion}" -- "$cur"))
      fi
    }

    complete -F _import_templates import-templates
'';
}
