{ nixpkgs, lib, ... }:

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

  nixpkgs.config.allowUnfree = true;
}
