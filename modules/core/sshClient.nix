{ hostname, ... }:
{
  programs.ssh  = {
    extraConfig = ''
      Host enseirb
        HostName ssh.enseirb-matmeca.fr
        User rjontef
        IdentityFile "~/.ssh/${hostname}" 
        IdentitiesOnly yes

      Host almapedago travail64 deepeirb
        User rjontef
        ProxyJump enseirb

      Host thor thor.enseirb-matmeca.fr
        HostName thor.enseirb-matmeca.fr
        IdentityFile "~/.ssh/${hostname}" 
        IdentitiesOnly yes

      Host github.com
        User git
        IdentityFile "~/.ssh/${hostname}" 
        IdentitiesOnly yes

      Host server 
        HostName 82.126.172.121
        User raph
        IdentityFile "~/.ssh/${hostname}" 
        IdentitiesOnly yes

      Host laptop
        HostName 192.168.1.38
        User raph
        IdentityFile "~/.ssh/${hostname}"
        IdentitiesOnly yes

      Host desktop
        HostName 192.168.1.104
        User raph
        IdentityFile "~/.ssh/${hostname}"
        IdentitiesOnly yes
        ProxyJump server
        
    '';
  };
}
