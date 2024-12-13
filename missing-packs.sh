#!/bin/bash

# Update and Install Required Packages
sudo apt-get update

# List of packages to install
packages=(
    isenkram-cli
    isenkram
    isenkram-autoinstall-firmware
)

# Install packages
for package in "${packages[@]}"; do
    sudo apt-get -y install "$package"
done

echo "Setup completed. All specified packages installed and configuration files created."
