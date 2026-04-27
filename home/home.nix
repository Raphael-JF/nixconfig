{ config, pkgs, lib, ... }:


let
    projectSituations = import ../make-codium/project-situations.nix { inherit pkgs; };
in


{

    
home-manager.users.raph = {
    imports = [
        ./gnome.nix
    ];


    home.username = "raph";
    home.homeDirectory = "/home/raph";

    home.file.".ssh/config_source" = {
    text = ''
        Host enseirb
        HostName ssh.enseirb-matmeca.fr
        User rjontef
        IdentityFile ~/.ssh/laptop
        AddKeysToAgent yes
        ForwardAgent yes

        Host almapedago travail64
        User rjontef
        ProxyJump enseirb

        Host thor thor.enseirb-matmeca.fr
        HostName thor.enseirb-matmeca.fr
        IdentityFile ~/.ssh/laptop
        IdentitiesOnly yes
        AddKeysToAgent yes

        Host github.com
        User git
        IdentityFile ~/.ssh/laptop
        IdentitiesOnly yes
        AddKeysToAgent yes
    '';

    onChange = ''
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
        cat ~/.ssh/config_source > ~/.ssh/config
        chmod 600 ~/.ssh/config
    '';
};

    programs.git = {
        enable = true;
        settings = {
            user = {
                userName = "Raphaël Jontef";
                userEmail = "raphael.jontef@enseirb-matmeca.fr";
            };
        };
        ignores = [
            ".clangd"
            ".clangd.local"
            "compile_commands.json"
            ".direnv"
            "flake.nix"
            "flake.lock"
            ".envrc"
            "*.idx"
        ];
    };

    programs.home-manager.enable = true;
    #https://search.nixos.org/packages
    home.packages = with pkgs; [
        # wl-clipboard
        # cliphist
        # grimblast
        # wofi
        # waybar
        # ssh
        firefox
        gnumake
        graphviz
        libimobiledevice
        valgrind
        evince
        gdb
        dconf-editor
        terminus-font
    ];

programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
};

programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhsWithPackages (_: projectSituations.minimal.packages);

    profiles.default = {
        enableExtensionUpdateCheck = false;
        enableMcpIntegration = false;
        enableUpdateCheck = false;

        # The extensions Visual Studio Code should be started with
        extensions = projectSituations.minimal.extensions;
      
        # Defines global user snippets
        globalSnippets = null;
        # Keybindings written to Visual Studio Code's keybindings.json
        keybindings = builtins.fromJSON (builtins.readFile ./vscode/keybindings.json);
        # Defines user snippets for different languages
        languageSnippets = {
            c = builtins.fromJSON (builtins.readFile ./vscode/snippets/c.json);
            latex = builtins.fromJSON (builtins.readFile ./vscode/snippets/latex.json);
        };
        # Configuration written to Visual Studio Code's mcp.json
        userMcp = {};
        # Configuration written to Visual Studio Code's settings.json
        userSettings = import ./vscode/settings.nix;
        # Configuration written to Visual Studio Code's tasks.json
        userTasks = {};
    };
};


programs.bash = {
    enable = true;
    initExtra = ''
        rebuild() {
        cd ~/Desktop/nixconfig
        git pull && sudo nixos-rebuild switch --flake ~/Desktop/nixconfig#$1
        }

        ide() {
        local repo="$HOME/Desktop/nixconfig/make-codium"
        local key
        local open_path=""
        local codium_state_root="$HOME/.local/share/codium-profiles"
        local codium_shared_user_dir="$HOME/.config/VSCodium/User"
        local codium_profile_dir
        local codium_user_data_dir
        local codium_profile_user_dir
        local codium_profile_global_storage
        local codium_profile_machine_id
        local codium_profile_storage_json
        local codium_profile_state_db
        local codium_profile_state_db_backup
        local shared_settings
        local shared_keybindings
        local shared_snippets
        local codium_shared_machine_id
        local codium_shared_global_storage
        local codium_shared_storage_json
        local codium_shared_state_db
        local codium_shared_state_db_backup
        local -a args

        args=("$@")

        if [[ $# -gt 0 ]]; then
            local last="''${args[$(( $# - 1 ))]}"

            if [[ "$last" == "." || "$last" == ".." || "$last" == ./* || "$last" == ../* || "$last" == /* || "$last" == ~* || "$last" == */* || -e "$last" ]]; then
                open_path="$last"
                unset 'args[$(( $# - 1 ))]'
            fi
        fi

        if [[ ''${#args[@]} -eq 0 ]]; then
            key="minimal"
        else
            key="$(printf '%s\n' "''${args[@]}" | sort -u | paste -sd- -)"
        fi

        codium_profile_dir="$codium_state_root/$key"
        codium_user_data_dir="$codium_profile_dir/user-data"
        codium_profile_user_dir="$codium_user_data_dir/User"
        codium_profile_global_storage="$codium_profile_user_dir/globalStorage"
        codium_profile_machine_id="$codium_user_data_dir/machineid"
        codium_profile_storage_json="$codium_profile_user_dir/storage.json"
        codium_profile_state_db="$codium_profile_user_dir/state.vscdb"
        codium_profile_state_db_backup="$codium_profile_user_dir/state.vscdb.backup"
        shared_settings="$codium_shared_user_dir/settings.json"
        shared_keybindings="$codium_shared_user_dir/keybindings.json"
        shared_snippets="$codium_shared_user_dir/snippets"
        codium_shared_machine_id="$HOME/.config/VSCodium/machineid"
        codium_shared_global_storage="$HOME/.config/VSCodium/globalStorage"
        codium_shared_storage_json="$codium_shared_user_dir/storage.json"
        codium_shared_state_db="$codium_shared_user_dir/state.vscdb"
        codium_shared_state_db_backup="$codium_shared_user_dir/state.vscdb.backup"

        if [[ -L "$codium_profile_user_dir" ]]; then
            rm "$codium_profile_user_dir"
        fi

        mkdir -p "$codium_profile_user_dir"
        mkdir -p "$codium_shared_user_dir"

        if [[ -d "$codium_profile_global_storage" && ! -L "$codium_profile_global_storage" ]]; then
            mkdir -p "$codium_shared_global_storage"
            cp -an "$codium_profile_global_storage/." "$codium_shared_global_storage/" 2>/dev/null || true
            rm -rf "$codium_profile_global_storage"
        fi

        mkdir -p "$codium_shared_global_storage"
        ln -sfn "$codium_shared_global_storage" "$codium_profile_global_storage"

        if [[ -e "$codium_profile_machine_id" && ! -L "$codium_profile_machine_id" && ! -e "$codium_shared_machine_id" ]]; then
            cp -a "$codium_profile_machine_id" "$codium_shared_machine_id"
        fi

        if [[ ! -e "$codium_shared_machine_id" ]]; then
            cat /proc/sys/kernel/random/uuid > "$codium_shared_machine_id"
        fi

        ln -sfn "$codium_shared_machine_id" "$codium_profile_machine_id"

        if [[ -e "$codium_profile_storage_json" && ! -L "$codium_profile_storage_json" && ! -e "$codium_shared_storage_json" ]]; then
            cp -a "$codium_profile_storage_json" "$codium_shared_storage_json"
        fi

        if [[ -e "$codium_profile_state_db" && ! -L "$codium_profile_state_db" && ! -e "$codium_shared_state_db" ]]; then
            cp -a "$codium_profile_state_db" "$codium_shared_state_db"
        fi

        if [[ -e "$codium_profile_state_db_backup" && ! -L "$codium_profile_state_db_backup" && ! -e "$codium_shared_state_db_backup" ]]; then
            cp -a "$codium_profile_state_db_backup" "$codium_shared_state_db_backup"
        fi

        ln -sfn "$codium_shared_storage_json" "$codium_profile_storage_json"
        ln -sfn "$codium_shared_state_db" "$codium_profile_state_db"

        if [[ -e "$codium_shared_state_db_backup" ]]; then
            ln -sfn "$codium_shared_state_db_backup" "$codium_profile_state_db_backup"
        fi

        if [[ -e "$shared_settings" ]]; then
            ln -sfn "$shared_settings" "$codium_profile_user_dir/settings.json"
        fi

        if [[ -e "$shared_keybindings" ]]; then
            ln -sfn "$shared_keybindings" "$codium_profile_user_dir/keybindings.json"
        fi

        if [[ -e "$shared_snippets" ]]; then
            ln -sfn "$shared_snippets" "$codium_profile_user_dir/snippets"
        fi

        if [[ -n "$open_path" ]]; then
            nix run "''${repo}#''${key}" -- \
                --user-data-dir "$codium_user_data_dir" \
                --new-window \
                "$open_path"
        else
            nix run "''${repo}#''${key}" -- \
                --user-data-dir "$codium_user_data_dir" \
                --new-window
        fi
        }

        _ide_complete() {
        local cur
        local profiles_file="$HOME/Desktop/nixconfig/make-codium/project-situations.nix"
        local profiles
        local profile_list=""
        local w

        cur="''${COMP_WORDS[COMP_CWORD]}"

        if [[ "$cur" == .* || "$cur" == /* || "$cur" == ~* ]]; then
            COMPREPLY=( $(compgen -f -- "$cur") )
            return 0
        fi

        if [[ -r "$profiles_file" ]]; then
            profiles="$(awk '/^  [a-zA-Z0-9_-]+ = \{/ {print $1}' "$profiles_file" | sed 's/$//' | grep -v '^full$')"
        fi

        if [[ -z "$profiles" ]]; then
            COMPREPLY=( $(compgen -W '. ..' -- "$cur") )
            return 0
        fi

        for w in $profiles; do
            case " ''${COMP_WORDS[*]} " in
                *" $w "*) ;;
                *) profile_list+="$w " ;;
            esac
        done

        COMPREPLY=( $(compgen -W "$profile_list" -- "$cur") )
        return 0
        }

        complete -F _ide_complete ide
    '';
};
    

    # wayland.windowManager.hyprland = {
    #     settings = import ./hyprland/hyprland.nix;
    #     enable = false;
    #     systemd.enable = false;
    # };
    home.stateVersion = "25.11";
};
}
