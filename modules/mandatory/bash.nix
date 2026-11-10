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
      rebuild = "nh os switch ~/nixconfig -H ${hostname}";

      ls = "eza --icons=auto";
      ll = "eza --icons=auto -lah --group";
      la = "eza --icons=auto -a";
      lt = "eza --icons=auto --tree --level=2";

      gst = "git status";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit";
      gcm = ''git commit -m'';
      gp = "git push";
      gpl = "git pull";


      "scan-disks" = "lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL,MODEL";
      "nixconfig-eval-server" = "nix eval --raw ~/nixconfig#nixosConfigurations.server.config.system.build.toplevel --show-trace" ;
      "nixconfig-eval-desktop" = "nix eval --raw ~/nixconfig#nixosConfigurations.desktop.config.system.build.toplevel --show-trace" ;
      "nixconfig-eval-laptop" = "nix eval --raw ~/nixconfig#nixosConfigurations.laptop.config.system.build.toplevel --show-trace" ;

    };

    promptInit = let
      promptColors = {
        desktop = ''\e[1;95m'';
        laptop  = ''\e[1;93m'';
        server  = ''\e[1;96m'';
      };
    in ''
      HOST_COLOR=$'${promptColors.${hostname}}'
      RESET=$'\e[0m'

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
        HOST_COLOR=$'\e[1;91m'
      else
        PROMPT_CHAR='$'
      fi

      PS1="\[$HOST_COLOR\]\n[\u@\h:\w\$(parse_git_branch)]$PROMPT_CHAR\[$RESET\] "
    '';
  };
}
