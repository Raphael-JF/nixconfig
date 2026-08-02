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

    automatic = lib.mkDefault false;

    dates = "weekly";

    options = "--delete-older-than 30d";
  };

  nixpkgs.config.allowUnfree = true;
}
