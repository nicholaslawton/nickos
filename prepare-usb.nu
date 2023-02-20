#!/usr/bin/env nu

def main [tag: string] {
  lsblk
  let dev = $"/dev/(input 'Enter device name (eg. sdb): ')"
  ls $dev
  do --ignore-program-errors { sudo umount --quiet $'($dev)*' }
  curl --location --fail $'https://github.com/nicholaslawton/nickos/releases/download/($tag)/nickos.iso' --output nickos.iso
  sudo dd if=nickos.iso $'of=($dev)' bs=4M conv=fsync status=progress
  rm nickos.iso
}
