ssid=$1
psk=$2
iface=$(ls -1 /sys/class/net | grep --max-count=1 --invert-match lo)

wpa_cli -i $iface add_network
wpa_cli -i $iface set_network 0 ssid $ssid
wpa_cli -i $iface set_network 0 psk $psk
wpa_cli -i $iface set_network 0 key_mgmt WPA-PSK
wpa_cli -i $iface enable_network 0
