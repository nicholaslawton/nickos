#!/usr/bin/env nu

let account = (whoami | str trim)

rm --recursive --force $account
cp --recursive home $account
open $'($account)/.gitconfig'
  | str replace '%email%' (git config user.email | str trim) --all
  | str replace '%name%' (git config user.name | str trim) --all
  | save $'($account)/.gitconfig'
open $'($account)/.config/nixpkgs/config.nix'
  | str replace '%account%' $account --all
  | save $'($account)/.config/nixpkgs/config.nix'
cp --recursive $account /home
rm --recursive --force --quiet $account
