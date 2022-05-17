{ system ? builtins.currentSystem
, nixpkgs ? <nixpkgs>
, copyPath ? import ./copy-path.nix { stdenv = (import nixpkgs {}).stdenv; }
}:

let
  nickos = copyPath "nickos-bootstrap" ./bootstrap;

  configuration = { pkgs, ... }: {
    imports = [
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    ];

    system.defaultChannel = "https://nixos.org/channels/nixos-unstable"

    networking.wireless.enable = true;

    environment.systemPackages = [ nickos ];
  };

  nixos = import "${nixpkgs}/nixos" { inherit system configuration; };
in
  { iso = nixos.config.system.build.isoImage; }
