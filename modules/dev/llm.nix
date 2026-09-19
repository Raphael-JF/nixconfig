{ pkgs, pkgs-opencode, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      pkgs-opencode.opencode
      (writeShellScriptBin "llm" (lib.readFile ./llm.sh))
    ];
    environment.etc."opencode.json".text = ''
{
	"$schema":"https://opencode.ai/config.json",
	"provider":{
		"lmstudio":{
			"npm":"@ai-sdk/openai-compatible",
			"name":"LM Studio (local)",
			"options":{
				"baseURL":"http://127.0.0.1:1234/v1"
			},
			"models":{
					"ministral-3-14b-instruct-2512": {  
					"name":"Ministral 3",
				      "options":{"temperature":0.1}	
				}
			}
		}
	}
}
    '';

    systemd.tmpfiles.rules = [
      "L+ /home/raph/.config/opencode/opencode.json - - - - /etc/opencode.json"
    ];
  };
}
