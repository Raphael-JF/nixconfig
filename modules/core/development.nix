{ pkgs, lib, config, ... }:
{
  options.packages.development.enable = lib.mkEnableOption "Enable development packages";
  
  config = {
    environment.systemPackages = lib.mkIf config.packages.development.enable [
      pkgs.gnumake
      pkgs.cmake
      pkgs.clang
      pkgs.clang-tools
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
  };
}
