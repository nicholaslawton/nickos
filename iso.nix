{config, pkgs, ...}:

let nickos = import ./nickos.nix; in

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  environment.systemPackages = [
    nickos.wifi-connect
  ];
}
