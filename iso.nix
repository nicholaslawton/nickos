{ system ? builtins.currentSystem, nixpkgs ? <nixpkgs>, nickos ? import ./nickos.nix }:

let
  configuration = { pkgs, ... }: {
    imports = [
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    ];

    environment.systemPackages = [
      nickos.wifi-connect
    ];
  };

  nixos = import "${nixpkgs}/nixos" { inherit system configuration; };
in
  { iso = nixos.config.system.build.isoImage; }
