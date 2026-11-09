{ hostname, ... }:
{
  programs.ssh  = {
    extraConfig = ''
      Host *
        IdentityFile "~/.ssh/${hostname}"
        IdentitiesOnly yes

      Host enseirb
        HostName ssh.enseirb-matmeca.fr
        User rjontef

      Host almapedago travail64 deepeirb 24p107-05
        User rjontef
        ProxyJump enseirb
        SetEnv TERM=xterm-256color

      Host thor 
        HostName thor.enseirb-matmeca.fr

      Host gh github.com
        HostName github.com
        User git

      Host server 
        HostName 82.126.172.121
        User raph

      Host laptop
        HostName 192.168.1.38
        User raph
        ProxyJump server

      Host desktop
        HostName 192.168.1.104
        User raph
        ProxyJump server
    '';
  };
}
