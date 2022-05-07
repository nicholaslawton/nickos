usage="Usage: $0 [wifi network name] [wifi password]"

ssid=${1?$usage}
psk=${2?$usage}

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
nixos-generate-config --root /mnt
echo "{ $ssid = { psk = \"$psk\"; }" > /mnt/etc/nixos/networking-wireless-networks.nix
cp /nix/store/*-nickos/configuration.nix /mnt/etc/nixos
nixos-install
reboot
