{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
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
    exfatprogs
    btrfs-progs
    parted
    compsize
    cryptsetup
  ];
}
