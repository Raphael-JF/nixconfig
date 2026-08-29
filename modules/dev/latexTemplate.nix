{ inputs, pkgs, ...}:
{
  config  ={
    environment.systemPackages = [
      inputs.latexTemplates.packages.${pkgs.system}.latexTemplate
    ];
  };
}
