#!/bin/bash

# Interface Wi-Fi et Ethernet
IFACE_WLAN="wlx40a5ef21ae00"
IFACE_ETH="wlo1"

echo "[+] Arrêt des services RogueAP..."
sudo pkill hostapd
sudo pkill dnsmasq
sudo pkill python3

echo "[+] Réinitialisation des règles iptables..."
sudo iptables --flush
sudo iptables -t nat --flush
sudo iptables -t mangle --flush
sudo iptables -X
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT

echo "[+] Désactivation du mode AP et retour à la configuration normale..."
sudo ip link set $IFACE_WLAN down
sudo ip addr flush dev $IFACE_WLAN
sudo ip link set $IFACE_WLAN up
sudo iw dev $IFACE_WLAN set type managed  # Remet en mode station

echo "[+] Rétablissement de la configuration réseau..."
sudo systemctl restart NetworkManager  # Redémarre le gestionnaire de réseau
sudo systemctl start systemd-resolved
echo "[✔] Réseau réinitialisé !"
