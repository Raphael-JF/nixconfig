{ ... }:
{
    programs.bash = {
        enable = true;
        shellAliases = {
            battery = "cat /sys/class/power_supply/BAT0/capacity";
        };
    };
}
