usage="Usage: $0 [WiFi network name] [WiFi password]"

ssid=${1?$usage}
psk=${2?$usage}

# Prepare disk

# TODO: erase disk
# TODO: partition

sudo mkfs.ext4 -L nixos /dev/sda8
sudo mkfs.fat -F 32 -n boot /dev/sda7

# Mount

sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot

# Prepare configuration

sudo nixos-generate-config --root /mnt
echo "{ $ssid = { psk = \"$psk\"; }; }" | sudo tee /mnt/etc/nixos/networking-wireless-networks.nix > /dev/null
sudo curl --output-dir /mnt/etc/nixos -O https://raw.githubusercontent.com/nicholaslawton/nickos/main/configuration.nix

# Install

sudo nixos-install

# Create user

echo Enter your details to create your user account
echo -n "Your full name: "
read name
echo -n "Account name for login: "
read login

sudo nixos-enter --command "useradd --comment '$name' --create-home $login; passwd $login"

curl --location https://api.github.com/repos/nicholaslawton/nickos/tarball | \
  tar --extract --gunzip --directory /mnt/home/$login --wildcards "*/home" --strip-components=2

reboot
