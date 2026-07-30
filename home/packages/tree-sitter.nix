{ stdenvNoCC, fetchurl, unzip }:

stdenvNoCC.mkDerivation {
  pname = "tree-sitter";
  version = "0.26.8";

  src = fetchurl {
    url = "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.8/tree-sitter-cli-linux-x64.zip";
    hash = "sha256-k3fYNHnujgXc59K1FEIIfH/dYgAVg0wk/qGobUvQqFs=";
  };

  nativeBuildInputs = [ unzip ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    unzip -j $src -d $out/bin
    chmod +x $out/bin/tree-sitter
    runHook postInstall
  '';
}
