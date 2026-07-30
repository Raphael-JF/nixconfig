{ ... }:
{
  environment.etc."kitty/kitty.conf".text = ''
    confirm_os_window_close 0
    font_size 12
    font_family FiraCode\ Nerd\ Font
    sync_to_monitor no
    input_delay 0
    repaint_delay 1
    map ctrl+shift+n no_op
  '';

  environment.variables.KITTY_CONFIG_DIRECTORY = "/etc/kitty";
}
