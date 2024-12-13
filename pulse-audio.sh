#!/bin/bash

# Update package list
sudo apt-get update

# List of packages to install
packages=(
    pulseaudio
    pavucontrol
    pamixer
    pulsemixer
    alsa-utils
    volumeicon-alsa
)

# Install packages
for package in "${packages[@]}"; do
    sudo apt-get -y install "$package"
done

echo "Setup completed. All specified packages installed."
