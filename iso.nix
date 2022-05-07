{ system ? builtins.currentSystem
, nixpkgs ? <nixpkgs>
, copyPath ? import ./copyPath.nix { stdenv = (import nixpkgs {}).stdenv; }
}:

let
  nickos = copyPath "nickos" ./nickos;

  configuration = { pkgs, ... }: {
    imports = [
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    ];

    networking.wireless.enable = true;

    environment.systemPackages = [ nickos ];
  };

  nixos = import "${nixpkgs}/nixos" { inherit system configuration; };
in
  { iso = nixos.config.system.build.isoImage; }
