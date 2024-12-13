#!/bin/bash

# List of packages to remove
packages=(
    cryptsetup
    cryptsetup-initramfs
    cryptsetup-bin
)

# Remove and purge the specified packages
for package in "${packages[@]}"; do
    sudo apt-get remove --purge -y "$package"
done

# Clean up the local repository of retrieved package files
sudo apt-get clean

# Remove unused packages and their configuration files
sudo apt-get autoremove --purge -y

echo "Specified packages have been removed, purged, and system cleaned up."
