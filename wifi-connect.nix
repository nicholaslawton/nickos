let pkgs = import <nixpkgs> {}; in

pkgs.writeShellScriptBin "wifi-connect" ''
  echo Hello World
''
