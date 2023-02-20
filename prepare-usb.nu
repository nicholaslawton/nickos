#!/usr/bin/env nu

def main [tag: string] {
  lsblk
  let name = input 'Enter device name (eg. sdb): '
  let dev = (ls --directory $'/dev/($name)' | first)
  if $dev.name == $'/dev/($name)' and $dev.type == 'block device' {
    do --ignore-program-errors { sudo umount --quiet $'($dev)*' }
    curl --location --fail $'https://github.com/nicholaslawton/nickos/releases/download/($tag)/nickos.iso' --output nickos.iso
    sudo dd if=nickos.iso $'of=($dev.name)' bs=4M conv=fsync status=progress
    rm nickos.iso
  } else {
    echo $'invalid device - "($name)" does not identify a block device'
    echo $dev
  }
}
