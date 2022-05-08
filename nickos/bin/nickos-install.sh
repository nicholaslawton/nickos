usage="Usage: $0 [wifi network name] [wifi password]"

ssid=${1?$usage}
psk=${2?$usage}

# Connect to WiFi

echo wpa_supplicant
sudo systemctl start wpa_supplicant

ifname=$(ls -1 /sys/class/net | grep --max-count=1 --invert-match lo)

echo ifname $ifname

status=$(wpa_cli -i $ifname status 2> /dev/null | grep wpa_state)
until [ "$status" = "wpa_state=DISCONNECTED" ]
do
  echo $status
  sleep 1
  status=$(wpa_cli -i $ifname status 2> /dev/null | grep wpa_state)
done

network=$(wpa_cli -i $ifname add_network)

echo add_network $network

echo set_network ssid
wpa_cli -i $ifname set_network $network ssid '"'$ssid'"'

echo set_network psk
wpa_cli -i $ifname set_network $network psk '"'$psk'"'

echo set_network key_mgmt
wpa_cli -i $ifname set_network $network key_mgmt WPA-PSK

echo enable_network
wpa_cli -i $ifname enable_network $network

echo connecting...
status=$(wpa_cli -i $ifname status | grep wpa_state)
until [ "$status" = "wpa_state=COMPLETED" ]
do
  echo $status
  sleep 1
  status=$(wpa_cli -i $ifname status | grep wpa_state)
done
echo $status

# Prepare disk

# TODO: erase disk
# TODO: partition

sudo mkfs.ext4 -L nixos /dev/sda8
sudo mkfs.fat -F 32 -n boot /dev/sda7

# Mount and prepare configuration

sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
sudo nixos-generate-config --root /mnt
echo "{ $ssid = { psk = \"$psk\"; }" | sudo tee /mnt/etc/nixos/networking-wireless-networks.nix > /dev/null
sudo cp /nix/store/*-nickos/configuration.nix /mnt/etc/nixos

# Install

nixos-install
reboot
