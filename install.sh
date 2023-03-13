usage="Usage: $0 [WiFi network name] [WiFi password]"

ssid=${1?$usage}
psk=${2?$usage}

ifname=$(ls -1 /sys/class/net | grep --max-count=1 --invert-match lo)

echo Enter your details to setup your user account
read -p "Your full name: " name
read -p "Account name for login: " login
read -p "Your e-mail address (for your Git identity): " email

# Prepare disk

until [[ $devname ]] && ls --directory $dev
do
  lsblk
  read -p "Enter the name of the target installation device (eg. sda): " devname
  dev=/dev/$devname
  if ! ls --directory $dev; then
    echo "$dev is not a valid device"
  fi
done

# TODO: erase disk

# Partition

lsblk
read -p "Press ENTER to continue"
sudo parted $dev -- mklabel gpt
lsblk
read -p "Press ENTER to continue"
sudo parted $dev -- mkpart primary 512MB -8GB
lsblk
read -p "Press ENTER to continue"
sudo parted $dev -- mkpart primary linux-swap -8GB 100%
lsblk
read -p "Press ENTER to continue"
sudo parted $dev -- mkpart ESP fat32 1MB 512MB
lsblk
read -p "Press ENTER to continue"
sudo parted $dev -- set 3 esp on
lsblk
read -p "Press ENTER to continue"

# Format

sudo mkfs.ext4 -L nixos ${dev}1
lsblk
read -p "Press ENTER to continue"
sudo mkswap -L swap ${dev}2
lsblk
read -p "Press ENTER to continue"
sudo mkfs.fat -F 32 -n boot ${dev}3
lsblk
read -p "Press ENTER to continue"

# Mount

sudo mount /dev/disk/by-label/nixos /mnt
lsblk
read -p "Press ENTER to continue"
sudo mkdir -p /mnt/boot
lsblk
read -p "Press ENTER to continue"
sudo mount /dev/disk/by-label/boot /mnt/boot
lsblk
read -p "Press ENTER to continue"

# Enable swap

sudo swapon ${dev}2
lsblk
read -p "Press ENTER to continue"

# Prepare configuration

sudo nixos-generate-config --root /mnt

sed --in-place "s/%ifname%/$ifname/" nixos/networking.nix
sed --in-place "s/%ssid%/$ssid/" nixos/networking.nix
sed --in-place "s/%psk%/$psk/" nixos/networking.nix
sed --in-place "s/%name%/$name/" nixos/users.nix
sed --in-place "s/%account%/$login/" nixos/users.nix

sudo cp --recursive nixos /mnt/etc

# Install

sudo nixos-install

# Set user password

sudo nixos-enter --command "echo \"Choose a password for your '$login' user account\"; passwd $login"

# Initialise home

sed --in-place "s/%name%/$name/" home/.gitconfig
sed --in-place "s/%email%/$email/" home/.gitconfig
sed --in-place "s/%account%/$login/" home/.config/nixpkgs/config.nix
sed --in-place "s/%account%/$login/" home/.config/nushell/env.nu

mv home $login
cp --recursive $login /mnt/home

# Reboot to finish

sudo reboot
