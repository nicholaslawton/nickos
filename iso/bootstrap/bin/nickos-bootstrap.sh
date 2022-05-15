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

ping -c 1 nixos.org
until [ $? -eq 0 ]
do
  sleep 1
  ping -c 1 nixos.org
done

# Continue with installation from current version of main install script

bash <(curl -s https://raw.githubusercontent.com/nicholaslawton/nickos/main/install.sh) $ssid $psk