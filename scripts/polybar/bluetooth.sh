#!/bin/bash

# Check if Bluetooth is powered on
if [ "$(bluetoothctl show | grep "Powered" | awk '{print $2}')" = "yes" ]; then
    echo " On"  # or any icon/text you prefer
else
    echo " Off"  # or any icon/text you prefer
fi


