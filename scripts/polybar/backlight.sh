#!/bin/bash

# Get the current brightness and maximum brightness
current=$(brightnessctl get)
max=$(brightnessctl max)

# Calculate the brightness as a percentage
brightness=$((current * 100 / max))

# Output the brightness level
echo "${brightness}%"

