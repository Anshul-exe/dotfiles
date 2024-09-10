#!/bin/bash

if systemctl is-active --quiet hostapd; then
  echo "Stopping services and removing iptables rules..."
  sudo systemctl stop hostapd
  sudo systemctl stop dnsmasq
  sudo iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
  sudo iptables -D FORWARD -i wlan0 -o eth0 -j ACCEPT
  notify-send "Hotspot band hogaya"
else
  echo "Starting services and adding iptables rules..."
  sudo systemctl start hostapd
  sudo systemctl start dnsmasq
  sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
  notify-send "Hotspot shuru hogaya"
fi
