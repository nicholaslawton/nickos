{ stdenv ? (import <nixpkgs> {}).stdenv }: name: src:

stdenv.mkDerivation {
  inherit name src;
  installPhase = "cp --recursive $src $out";
}
