{ pkgs, ... }:
{
  imports = [
    ./latexTemplate.nix
    ./llm.nix
  ]; 
  
  config = {
    environment.systemPackages = [
      pkgs.gnumake
      pkgs.cmake

      # latex
      pkgs.texliveFull
      pkgs.texlab

      # compilation
      pkgs.flex
      pkgs.bison
      
      # java 
      pkgs.openjdk
    ];
  };
}
