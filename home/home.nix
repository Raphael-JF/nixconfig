{ config, pkgs, my-nvim, ... }:

{
    home-manager.extraSpecialArgs = {
        raph = {
            hostType = config.raph.hostType;
        };
        inherit pkgs;
        inherit my-nvim;
    };

    home-manager.users.raph = ./home-manager.nix;
}
