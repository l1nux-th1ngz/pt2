#!/bin/bash

# Update package list
sudo apt-get update

# List of packages to install
packages=(
    xinit
    lightdm
    lightdm-settings
    lightdm-gtk-greeter
    lightdm-gtk-greeter-settings
    slick-greeter
)

# Install packages
for package in "${packages[@]}"; do
    sudo apt-get -y install "$package"
done

# Autologin setup
echo "Enabling autologin (sudo password required)..."
sudo bash -c 'echo "[Seat:*]
autologin-user=${SUDO_USER}
autologin-user-timeout=0
user-session=default
" > /etc/lightdm/lightdm.conf'

# Configure Slick Greeter
sudo bash -c 'echo "[Seat:*]
greeter-session=slick-greeter
user-session=default
" >> /etc/lightdm/lightdm.conf'

# Show username on login screen
sudo bash -c 'echo "[Seat:*]
greeter-hide-users=false
" >> /etc/lightdm/lightdm.conf'

# Allow guest login
sudo bash -c 'echo "[Seat:*]
allow-guest=true
" >> /etc/lightdm/lightdm.conf'

# Enable LightDM service
sudo systemctl enable lightdm.service

# Start LightDM service
sudo systemctl start lightdm.service

# Create .xinitrc if it doesn't exist
[ ! -f "$HOME/.xinitrc" ] && touch "$HOME/.xinitrc"

echo "LightDM has been installed and configured. Slick Greeter is set as the default, username is shown, and root login is allowed."
