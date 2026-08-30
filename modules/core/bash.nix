{ hostname, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    eza
    nerd-fonts.fira-code
  ];

  programs.bash = {
    enable = true;

    shellAliases = {
      battery = "cat /sys/class/power_supply/BAT0/capacity";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixconfig#${hostname}";

      ls = "eza --icons";
      ll = "eza --icons -lah";
      la = "eza --icons -a";
      lt = "eza --icons --tree --level=2";
    };

    promptInit = ''
      case "$HOSTNAME" in
        raph-desktop)
          HOST_COLOR='\[\e[1;95m\]'
          ;;
        raph-laptop)
          HOST_COLOR='\[\e[1;93m\]'
          ;;
        raph-server)
          HOST_COLOR='\[\e[1;96m\]'
          ;;
        *)
          HOST_COLOR='\[\e[1;92m\]'
          ;;
      esac

      RESET='\[\e[0m\]'

      parse_git_branch() {
        local branch
        branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return

        if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
          echo " ($branch *)"
        else
          echo " ($branch)"
        fi
      }

      if [[ $EUID -eq 0 ]]; then
        PROMPT_CHAR='#'
        HOST_COLOR='\[\e[1;91m\]'
      else
        PROMPT_CHAR='$'
      fi

      PS1="$HOST_COLOR\n[\u@\h:\w\$(parse_git_branch)]$PROMPT_COLOR$PROMPT_CHAR$RESET "
    '';
  };
}
