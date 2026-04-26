{ pkgs, projectSituations ? import ./project-situations.nix { inherit pkgs; } }:

let
  lib = pkgs.lib;

  baseProfileName = "minimal";
  availableProfileNames = builtins.attrNames projectSituations;
  selectableProfileNames = builtins.filter (name: name != baseProfileName && name != "full") availableProfileNames;

  mkVscodium = profiles:
    let
      profileList = if builtins.isList profiles then profiles else [ profiles ];

      mergedPackages = lib.unique (builtins.concatLists (map (profile: profile.packages or [ ]) profileList));
      mergedExtensions = lib.unique (builtins.concatLists (map (profile: profile.extensions or [ ]) profileList));
    in
    pkgs.vscode-with-extensions.override {
      vscode = pkgs.vscodium.fhsWithPackages (_: mergedPackages);
      vscodeExtensions = mergedExtensions;
    };

  mkFromNames = names:
    let
      unknown = builtins.filter (name: !(builtins.elem name availableProfileNames)) names;
    in
    if unknown != [ ] then
      throw "Unknown VSCodium profile(s): ${builtins.concatStringsSep ", " unknown}"
    else
      mkVscodium (map (name: projectSituations.${name}) ([ baseProfileName ] ++ names));

  subsets = names:
    if names == [ ] then [ [ ] ] else
      let
        tailSubsets = subsets (builtins.tail names);
        head = builtins.head names;
      in
      tailSubsets ++ map (subset: [ head ] ++ subset) tailSubsets;

  generatedPackages = builtins.listToAttrs (map
    (names: {
      name = if names == [ ] then baseProfileName else builtins.concatStringsSep "-" names;
      value = mkFromNames names;
    })
    (subsets selectableProfileNames));
in
{
  inherit mkVscodium mkFromNames selectableProfileNames;

  packages = generatedPackages // {
    default = generatedPackages.${baseProfileName};
    full = mkFromNames [ "full" ];
  };
}