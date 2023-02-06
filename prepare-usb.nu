#!/usr/bin/env nu

def main [tag: string] {
  lsblk

  let dev = $"/dev/(input 'Enter device name (eg. sdb): ')"

  ls $dev

  do --ignore-program-errors { sudo umount --quiet $'($dev)*' }

  curl --location https://github.com/nicholaslawton/nickos/releases/download/$tag/nixos.iso --output nickos.iso

  ls nickos.iso

  echo $dev
  # The use of $dev variable in the below command is taken literally for some reason...
  #sudo dd if=nickos.iso of=$dev bs=4M conv=fsync status=progress

  rm nickos.iso
}
