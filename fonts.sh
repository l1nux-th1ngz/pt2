#!/bin/bash

# Update package list
sudo apt-get update

# List of packages to install
packages=(
    # Fonts
    fonts-recommended
    fonts-font-awesome
    fonts-terminus
    fonts-powerline
    fonts-ubuntu
    fonts-liberation2
    fonts-liberation
    fonts-cascadia-code
    fonts-recommended
    fonts-font-awesome
    fonts-terminus
    fonts-cascadia-code
    fonts-firacode
    fonts-hack
    fonts-inconsolata
    fonts-jetbrains-mono
    fonts-meslo-lg
    fonts-mononoki
    fonts-roboto-mono
    fonts-source-code-pro
    fonts-ubuntu-mono

    # Icons
    papirus-icon-theme
)

# Install packages
for package in "${packages[@]}"; do
    sudo apt-get -y install "$package"
done

echo "All specified fonts and icon themes have been installed."
