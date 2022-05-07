usage="Usage: $0 [wifi network name] [wifi password]"

ssid=${1?$usage}
psk=${2?$usage}
configPath=${3-"/mnt/etc/nixos"}

sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
sudo nixos-generate-config --root /mnt
echo "{ $ssid = { psk = \"$psk\"; }" > /mnt/etc/nixos/networking-wireless-networks.nix
cp /nix/store/*-nickos/configuration.nix /mnt/etc/nixos
