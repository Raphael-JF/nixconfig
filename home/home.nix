{ config, pkgs, ... }:

{
    home-manager.extraSpecialArgs = {
        raph = {
            hostType = config.raph.hostType;
        };
        inherit pkgs;
    };

    home-manager.users.raph = ./home-manager.nix;
}
