#!/usr/bin/env nu

let account = (whoami | str trim)

def substitutions [file: path] {
  open $file
    | decode utf-8
    | str replace --all '%email%' (git config user.email | str trim)
    | str replace --all '%name%' (git config user.name | str trim)
    | str replace --all '%account%' $account
    | save $file
}

rm --recursive --force $account
cp --recursive home $account

ls --all $'($account)/**/*'
  | where type == file
  | get name
  | each { |it| substitutions $it }

cp --recursive $account /home
rm --recursive --force $account
