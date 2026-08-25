{ pkgs, lib, config, ... }:
{
  options.packages.development.enable = lib.mkEnableOption "Enable development packages";
  
  config = {
    environment.systemPackages = lib.mkIf config.packages.development.enable [
      pkgs.gnumake
      pkgs.cmake
      pkgs.clang
      pkgs.clang-tools
      pkgs.texliveFull
      pkgs.valgrind
      pkgs.gdb
      pkgs.bear
      # pkgs.aider-chat
      pkgs.graphviz
      (
        pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
          numpy
          matplotlib
          scipy
          mip 
          highspy
          pyserial
        ])
      )
      pkgs.texliveSmall

    ];
    # run kitty at startup
    environment.etc."xdg/autostart/kitty.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Kitty
      Exec=${pkgs.kitty}/bin/kitty
      X-GNOME-Autostart-enabled=true
    '';
  };
}
