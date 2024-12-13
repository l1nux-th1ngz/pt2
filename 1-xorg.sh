#!/bin/bash

# Update and Install Required Packages
sudo apt-get update

# List of packages to install
packages=(
    xorg 
    xserver-xorg
)

# Install the packages
for package in "${packages[@]}"; do
    sudo apt-get install -y "$package"
done

# Set Xorg as the default video server
# Create a symbolic link if necessary (depends on the system setup)
sudo ln -sf /usr/bin/Xorg /etc/alternatives/x-session-manager

echo "Xorg installation complete and set as default video server."
