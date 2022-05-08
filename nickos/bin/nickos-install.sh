# Connect to WiFi

echo Enter your WiFi network details
echo -n "Network name: "
read ssid
echo -n "Password: "
read psk

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
echo "{ $ssid = { psk = \"$psk\"; }; }" | sudo tee /mnt/etc/nixos/networking-wireless-networks.nix > /dev/null
sudo cp /nix/store/*-nickos/configuration.nix /mnt/etc/nixos

# Install

sudo nixos-install

# Create user

echo Enter your details to create your user account
echo -n "Your full name: "
read name
echo -n "Account name for login: "
read login

sudo nixos-enter --command "useradd --comment '$name' --create-home $login; passwd $login"

echo reboot
#reboot
