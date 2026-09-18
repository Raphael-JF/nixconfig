{ pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      opencode
      pkgs.writeShellScriptBin "llm" lib.readFile ./llm.sh
    ];
  };
}
