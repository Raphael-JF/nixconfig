{ pkgs, ... }:

{
  nix.settings = {

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    auto-optimise-store = true;
  };


  nix.gc = {
    automatic = false;
  };

  programs.nh = {
    enable = true;
  };
  
  environment.systemPackages = [
      pkgs.nil
  ];

  nixpkgs.config.allowUnfree = true;
}
