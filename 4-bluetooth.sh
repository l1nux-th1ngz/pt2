#!/bin/bash

# Update and Install Required Packages
sudo apt-get update

echo "Installing Bluetooth services..."

# List of packages to install
packages=(
    bluez
    blueman
    bluemon 
    bluez-obexd
)

# Install packages
for package in "${packages[@]}"; do
    sudo apt-get -y install "$package"
done

echo "Bluetooth services installed."

# Enable Bluetooth service to start on boot
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

echo "Bluetooth services enabled and started."
