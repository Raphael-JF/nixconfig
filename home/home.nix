{ config, ... }:

{
    home-manager.extraSpecialArgs = {
        raph = {
            hostType = config.raph.hostType;
        };
    };

    home-manager.users.raph = import ./home-manager.nix;
}
