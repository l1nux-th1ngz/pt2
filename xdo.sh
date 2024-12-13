#!/bin/bash

# Update and Install Required Packages
sudo apt-get update

# List of packages to install
packages=(
    intel-microcode
    qt5ct
    uxplay
    wmname
    brightnessctl
    playerctl
    xprop
    xdotool
    xdo
    fzf
    firefox-esr
)

# Install packages
for package in "${packages[@]}"; do
    sudo apt-get -y install "$package"
done

echo "Setup completed. All specified packages installed."
