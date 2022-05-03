{ pkgs ? import <nixpkgs> {} }:

import ./scripts pkgs.writeShellScriptBin
