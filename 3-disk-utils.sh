#!/bin/bash

# Update and Install Required Packages
sudo apt-get update

# List of packages to install
packages=(
    udisks2
    dosfstools
    e2fsprogs
    exfatprogs 
    libpam-systemd 
    ntfs-3g
    btrfs-progs
    udiskie 
    parted
    gparted
    gnome-disk-utility 
)

# Install packages
for package in "${packages[@]}"; do
    sudo apt-get -y install "$package"
done

echo "Setup completed. All specified packages installed and configuration files created."
