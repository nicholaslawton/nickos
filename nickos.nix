{ nixpkgs ? import <nixpkgs> {} }:

let
  fileName = path:
    let
      s = builtins.baseNameOf path;
      m = builtins.match ''(.*)\.[^.]*'' s;
    in
      if m == null || m == [] then s else builtins.head m;

  script = path: nixpkgs.writeShellScriptBin (fileName path) (builtins.readFile path);

  scripts = dir:
    let
      namedScript = name: type:
        let path = dir + "/${name}"; in
        if type == "regular" && builtins.match ''.+\.sh'' name != null
        then { name = fileName path; value = script path; }
        else null;

      namedScripts = d: builtins.filter (x: x != null) (builtins.attrValues (builtins.mapAttrs namedScript d));
    in
      builtins.listToAttrs (namedScripts (builtins.readDir dir));
in
  scripts ./scripts
