{ inputs, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    inputs.my-nvim.packages.${pkgs.system}.default #nvim
    wget
    curl  
    htop  
    btop  
    tree  
    tmux  
    unzip  
    pciutils  
    usbutils  
    lsof
  ];
}
