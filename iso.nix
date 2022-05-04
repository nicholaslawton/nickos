{ system ? builtins.currentSystem
, nixpkgs ? <nixpkgs>
, nickos ? import ./nickos.nix { pkgs = import nixpkgs {}; }
}:

let
  configuration = { pkgs, ... }: {
    imports = [
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    ];

    networking.wireless.enable = true;

    environment.systemPackages = [
      nickos.wifi-connect
    ];
  };

  nixos = import "${nixpkgs}/nixos" { inherit system configuration; };
in
  { iso = nixos.config.system.build.isoImage; }
