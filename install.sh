usage="Usage: $0 [WiFi network name] [WiFi password]"

ssid=${1?$usage}
psk=${2?$usage}

ifname=$(ls -1 /sys/class/net | grep --max-count=1 --invert-match lo)

echo Enter your details to setup your user account
read -p "Your full name: " name
read -p "Account name for login: " login
read -p "Your e-mail address (for your Git identity): " email

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

mv home $login
cp --recursive $login /mnt/home

# Reboot to finish

reboot
