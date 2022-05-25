#!/usr/bin/env nu

let account = (whoami | str trim)

def substitutions [file: path] {
  open $file
    | str replace '%email%' (git config user.email | str trim) --all
    | str replace '%name%' (git config user.name | str trim) --all
    | str replace '%account%' $account --all
    | save $file
}

rm --recursive --force --quiet $account
cp --recursive home $account

ls -a $'($account)/**/*'
  | where type == file
  | get name
  | each { |it| substitutions $it }

cp --recursive $account /home
rm --recursive --force --quiet $account
