{ pkgs, ... }:
{
  imports = [
    ./latexTemplate.nix
    ./llm.nix
  ]; 
  
  config = {
    environment.systemPackages = [
      pkgs.gnumake

      # C
      pkgs.clang-tools
      pkgs.gcc
      pkgs.cmake

      # latex
      pkgs.texliveFull
      pkgs.texlab

      # compilation
      pkgs.flex
      pkgs.bison
      
      # java 
      pkgs.openjdk
      pkgs.plantuml
      pkgs.graphviz
      pkgs.inkscape
    ];
  };
}
