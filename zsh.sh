#!/bin/bash

# Update and Install Required Packages
sudo apt-get update

# List of packages to install
packages=(
    zsh
    zsh-dev
    zsh-antigen
    zsh-antidote
    zsh-common
    zsh-syntax-highlighting
    zsh-theme-powerlevel9k
    powerline
    fonts-powerline
    python3-powerline
)

# Install packages
for package in "${packages[@]}"; do
    sudo apt-get -y install "$package"
done

# Copy configuration files to Home directory
cp .p10k.zsh "$HOME"/
cp .zshrc "$HOME"/

echo "Setup completed. All specified packages installed and configuration files copied to Home directory."
