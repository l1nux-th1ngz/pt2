#!/bin/bash

# Update and Install Required Packages
sudo apt-get update

# List of packages to install
packages=(
    polkitd
    policykit-1-gnome 
    polkitd-pkla
    dialog
    feh
    dosfstools
    upower 
    gnome-power-manager
    xdotool
    zip
    unzip
    gnome-power-manager
    xdg-utils
    libnotify4
    notification-daemon
    adduser
    passwd
    binutils
    binutils-common
    dex
    binutils-x86-64-linux-gnu
    desktop-file-utils
    dconf-editor
    hwinfo
    hw-probe
    lolcat
    silversearcher-ag
    nala
)

# Install packages
for package in "${packages[@]}"; do
    sudo apt-get -y install "$package"
done

echo "Setup completed. All specified packages installed and configuration files created."
